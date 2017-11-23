import time
import struct
import logging
from ryu.lib.mac import haddr_to_str

from ryu.base import app_manager

from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls

from ryu.ofproto import ofproto_v1_3
from ryu.ofproto import ether
from ryu.ofproto import inet

from ryu.lib import hub

from ryu.lib.packet import packet
from ryu.lib.packet import vlan
from ryu.lib.packet import cfm
from ryu.lib.packet import lldp
from ryu.lib.packet import ipv4
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types

from ryu import utils
import time
import numpy as np

# <--- db declaration
import peewee
import MySQLdb

db = peewee.MySQLDatabase("ryu_db", host="mat.ns.ie.u-ryukyu.ac.jp", port=3306, user="root", passwd="")

class Topology(peewee.Model):
    id = peewee.IntegerField()
    dport1 = peewee.CharField()
    dport2 = peewee.CharField()
    delay = peewee.FloatField()
    judge = peewee.CharField()
    updated = peewee.IntegerField()


    class Meta:
        database = db

# --->

LOG = logging.getLogger(__name__)

class Switch13(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(Switch13, self).__init__(*args, **kwargs)
        # initialize mac address table.
        self.mac_to_port = {}
        self.datapaths = []
        self.dport_id = []
        self.hostname = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        self.dport = np.empty((0,2), int)
        self.hw_addr = '88:d7:f6:7a:34:90'
        self.ip_addr = '10.50.0.100'
        self.vlan_type=ether.ETH_TYPE_8021Q
        self.ipv4_type=ether.ETH_TYPE_IP
        self.lldp_type=ether.ETH_TYPE_LLDP
        self.lldp_thread = hub.spawn(self.lldp_loop)

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        self.datapaths.append(datapath)

        match = parser.OFPMatch(eth_type=self.lldp_type)
        actions = [parser.OFPActionOutput(ofproto.OFPP_CONTROLLER,ofproto.OFPCML_NO_BUFFER)]

        self.add_flow(datapath, 1, match, actions)

        self.send_port_desc_stats_request(datapath)

    def lldp_loop(self):
        while True:
            self.insert_host()
            self.dport = np.empty((0,2), int)
            self.dport_id = []
            for dp in self.datapaths:
                self.send_port_desc_stats_request(dp)
            hub.sleep(10)

    def send_port_desc_stats_request(self, datapath):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        req = parser.OFPPortDescStatsRequest(datapath, 0, ofproto.OFPP_ANY)
        datapath.send_msg(req)

    # add flow
    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
 
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                match=match, instructions=inst)
        datapath.send_msg(mod)
    
    def del_flow(self, vlan):
        for dp in self.datapaths: 
            ofproto = dp.ofproto
            parser = dp.ofproto_parser

            match = parser.OFPMatch(vlan_vid=(int(vlan) | ofproto.OFPVID_PRESENT))

            # construct flow_mod message and send it.
            inst = []
            mod = parser.OFPFlowMod(datapath=dp, priority=1,
                                command=ofproto.OFPFC_DELETE, out_port=ofproto.OFPP_ANY, out_group=ofproto.OFPG_ANY, match=match, instructions=inst)
            dp.send_msg(mod)

    @set_ev_cls(ofp_event.EventOFPPortDescStatsReply, MAIN_DISPATCHER)
    def port_desc_stats_reply_handler(self, ev):
        msg = ev.msg
        datapath = msg.datapath
        ofproto = datapath.ofproto
        
        for stat in ev.msg.body:
            if stat.port_no < ofproto.OFPP_MAX:
                self.dport = np.append(self.dport, np.array([[datapath.id, stat.port_no]]), axis=0)
                self.send_lldp_packet(datapath, stat.port_no, stat.hw_addr)
 
    
    def send_lldp_packet (self, datapath, port_no, hw_addr):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        timestamp = time.time()

        pkt = packet.Packet()
        pkt.add_protocol(ethernet.ethernet(ethertype=self.lldp_type, src=hw_addr, dst=lldp.LLDP_MAC_NEAREST_BRIDGE))
 
        tlv_chassis_id = lldp.ChassisID(subtype=lldp.ChassisID.SUB_LOCALLY_ASSIGNED, chassis_id=str(datapath.id))
        tlv_port_id = lldp.PortID(subtype=lldp.PortID.SUB_LOCALLY_ASSIGNED, port_id=str(port_no))
        tlv_ttl = lldp.TTL(ttl=10)
        tlv_time = lldp.TimeStamp(timestamp=timestamp)
        tlv_end = lldp.End()
        tlvs = (tlv_chassis_id, tlv_port_id, tlv_ttl, tlv_time, tlv_end)
        pkt.add_protocol(lldp.lldp(tlvs))
        pkt.serialize()
        data = pkt.data

        actions = [parser.OFPActionOutput(port_no)]
        out = parser.OFPPacketOut(datapath=datapath,
                                  buffer_id=ofproto.OFP_NO_BUFFER,
                                  in_port=ofproto.OFPP_CONTROLLER,
                                  actions=actions,
                                  data=data)
        datapath.send_msg(out)
    
    
    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def _packet_in_handler(self, ev):
        msg = ev.msg
        datapath = msg.datapath
        port = msg.match['in_port']
        pkt = packet.Packet(data=msg.data)
        dst, src, eth_type = struct.unpack_from('!6s6sH', buffer(msg.data), 0)
        in_port = msg.match.fields[0].value

 
        pkt_ethernet = pkt.get_protocol(ethernet.ethernet)
        if not pkt_ethernet:
            return
 
        pkt_lldp = pkt.get_protocol(lldp.lldp)
        if pkt_lldp:
            self.search_host(datapath, port)
            self.handle_lldp(datapath, port, pkt_lldp)
        else:
            LOG.info("----------------------------------------")
            LOG.info("* PacketIn")
            LOG.info("in_port=%d, eth_type: %s", in_port, hex(eth_type))
            LOG.info("packet reason=%d buffer_id=%d", msg.reason, msg.buffer_id)
            LOG.info("packet in datapath_id=%s src=%s dst=%s",
                      msg.datapath.id, haddr_to_str(src), haddr_to_str(dst))
    
    def handle_lldp(self, datapath, port, pkt_lldp):
        timestamp_diff = time.time() - pkt_lldp.tlvs[3].timestamp

        # <--- db 
        if datapath.id is not None:
            if int(datapath.id) > int(pkt_lldp.tlvs[0].chassis_id):
                sid1 = str(pkt_lldp.tlvs[0].chassis_id) + "-" + str(pkt_lldp.tlvs[1].port_id)
                sid2 = str(datapath.id) + "-" + str(port)
            else:
                sid1 = str(datapath.id) + "-" + str(port)
                sid2 = str(pkt_lldp.tlvs[0].chassis_id) + "-" + str(pkt_lldp.tlvs[1].port_id)
            
            print sid1 + " , " + sid2
            topo = Topology.select().where((Topology.dport1 == sid1) & (Topology.dport2 == sid2)) 
            if topo.exists():
                print "update"
                # <--- db update
                topo = Topology.update(delay=timestamp_diff,updated=time.time()).where((Topology.dport1 == sid1) & (Topology.dport2 == sid2))
                topo.execute()
                # db update --->
            else:
                # <--- db insert
                print "insert"
                topo = Topology.insert(dport1=sid1,dport2=sid2,delay=timestamp_diff,judge='S',updated=time.time())
                topo.execute()
                # db insert --->
            
        # <--- db delete
        Topology.delete().where((time.time() - Topology.updated) > 20).execute()
        # ---> db delete

    def search_host(self, datapath, port):
        self.dport = np.delete(self.dport, np.where((self.dport[:,0]==datapath.id) & (self.dport[:,1]==port)), 0)
    
    def insert_host(self):
        for i in range(len(self.dport)):
            sid = str(self.dport[i][0]) + "-" + str(self.dport[i][1])
            self.dport_id.append(sid)
        self.dport_id.sort()

        for j in range(len(self.dport_id)):
            print self.dport_id[j]
            hoge = Topology.select().where(Topology.dport1 == self.dport_id[j])
            
            if hoge.exists():
                print "update"
                # <--- db update
                topo = Topology.update(updated=time.time()).where((Topology.dport1 == self.dport_id[j]) & (Topology.dport2 == self.hostname[j]))
                topo.execute()
                # db update --->
            else:
                # <--- db insert
                print "insert"
                topo = Topology.insert(dport1=self.dport_id[j], dport2=self.hostname[j], judge='H', updated=time.time())
                topo.execute()
                # db insert --->
            
            # <--- db delete
        Topology.delete().where((time.time() - Topology.updated) > 10).execute()
        # ---> db delete