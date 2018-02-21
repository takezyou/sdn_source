import time
import struct
import logging

from ryu.lib.mac import haddr_to_str
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER, DEAD_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.controller import dpset

from ryu.ofproto import ofproto_v1_3
from ryu.ofproto import ether
from ryu.ofproto import inet

from ryu.lib import hub
from ryu.lib import dpid as dpid_lib
from ryu.lib.packet import packet
from ryu.lib.packet import vlan
from ryu.lib.packet import lldp
from ryu.lib.packet import ipv4
from ryu.lib.packet import arp
from ryu.lib.packet import ethernet
from ryu.lib.packet import ether_types
from ryu import utils
import subprocess
import re
import time
import numpy as np
import itertools

# <--- db declaration
import peewee
import MySQLdb


db = peewee.MySQLDatabase("ryu_db", host="star.ns.ie.u-ryukyu.ac.jp", port=3306, user="root", passwd="ogwfASGM+38p")

class Visualization_topologies(peewee.Model):
    id = peewee.IntegerField()
    dport1 = peewee.CharField()
    dport2 = peewee.CharField()
    delay = peewee.FloatField()
    judge = peewee.CharField()
    updated = peewee.IntegerField()
    class Meta:
        database = db

class Visualization_vlans(peewee.Model):
    vlanid = peewee.IntegerField(primary_key=True)
    start = peewee.CharField()
    end = peewee.CharField()
    path = peewee.CharField()
    created_at = peewee.CharField()
    updated_at = peewee.CharField()
    path_length = peewee.IntegerField()
    class Meta:
        database = db 

class Visualization_route(peewee.Model):
    id = peewee.IntegerField(primary_key=True)
    start = peewee.CharField()
    end = peewee.CharField()
    route = peewee.TextField()
    updated = peewee.IntegerField()
    class Meta:
        database = db

class Visualization_datapath(peewee.Model):
    id = peewee.IntegerField()
    datapath = peewee.TextField()
    object_datapath = peewee.TextField()

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
        self.table = 0
        self.test_time = time.time()
        # self.hostname = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"] 
        self.hw = '88:d7:f6:7a:34:90'
        self.ip = '10.50.0.101'
        self.vlan_type=ether.ETH_TYPE_8021Q
        self.ipv4_type=ether.ETH_TYPE_IP
        self.arp_type=ether.ETH_TYPE_ARP
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

        # match = parser.OFPMatch(eth_type=self.lldp_type)
        # actions = [parser.OFPActionOutput(ofproto.OFPP_CONTROLLER,ofproto.OFPCML_NO_BUFFER)]
        # self.add_flow(datapath, 1, match, actions)

        self.send_port_desc_stats_request(datapath)

    def lldp_loop(self):
        while True:
            self.connection()
            # self.insert_host()
            self.dport_id = []
            datapaths = Visualization_datapath.select()
            for dp in self.datapaths:
                self.send_port_desc_stats_request(dp)
                self.insert_route()
            hub.sleep(20)

    @set_ev_cls(dpset.EventDP, dpset.DPSET_EV_DISPATCHER)
    def handler_datapath(self, ev):
        if ev.enter:
            self.regist(ev.dp)
        # else:
        #     self.unregist(ev.dp)

    def send_port_desc_stats_request(self, datapath):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        req = parser.OFPPortDescStatsRequest(datapath, 0, ofproto.OFPP_ANY)
        datapath.send_msg(req)

    def regist(self, dp):
        dpid_str = dpid_lib.dpid_to_str(dp.id)
        datapath = Visualization_datapath.select().where(Visualization_datapath.datapath == dpid_str) 
        if not datapath.exists():
            datapath = Visualization_datapath.insert(datapath=dpid_str,object_datapath=dp)
            datapath.execute()
        # datapath = Visualization_datapath.select().where(Visualization_datapath.datapath == dpid_str) 
        cmd = """curl -X PUT -d '""' http://10.50.0.101:8080/v1.0/conf/switches/""" + datapath[0].datapath + "/ovsdb_addr"
        subprocess.call(cmd, shell=True)
    
    def unregist(self, dp):
        dpid_str = dpid_lib.dpid_to_str(dp.id)
        Visualization_datapath.delete().where(Visualization_datapath.datapath==dpid_str).execute()
        Visualization_datapath.delete().where(Visualization_datapath.object_datapath==dp).execute()

    # add flow
    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
 
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                match=match, instructions=inst)
        datapath.send_msg(mod)
    
    def del_flow(self, vlan, port1, port2):
        for dp in self.datapaths:
                    
            ofproto = dp.ofproto
            parser = dp.ofproto_parser
            match = parser.OFPMatch(vlan_vid=(int(vlan) | ofproto.OFPVID_PRESENT))
            inst = []
            mod = parser.OFPFlowMod(datapath=dp, priority=1,
                                command=ofproto.OFPFC_DELETE, out_port=ofproto.OFPP_ANY, out_group=ofproto.OFPG_ANY, match=match, instructions=inst)
            dp.send_msg(mod)
            match = parser.OFPMatch(in_port=int(port1))
            inst = []
            mod = parser.OFPFlowMod(datapath=dp, priority=1,
                                command=ofproto.OFPFC_DELETE, out_port=ofproto.OFPP_ANY, out_group=ofproto.OFPG_ANY, match=match, instructions=inst)
            dp.send_msg(mod)
            match = parser.OFPMatch(in_port=int(port2))
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
                self.send_lldp_packet(datapath, stat.port_no, stat.hw_addr)
                if stat.curr_speed > 1:
                    dport = str(datapath.id) + "-" + str(stat.port_no)
                    host = Visualization_topologies.select().where(Visualization_topologies.dport1 == dport)
                    if host.exists():
                        topo = Visualization_topologies.update(updated=time.time()).where((Visualization_topologies.dport1 == dport) & (Visualization_topologies.dport2 == stat.name))
                        topo.execute()
                    else:
                        topo = Visualization_topologies.insert(dport1=dport, dport2=stat.name, judge='H', updated=time.time())
                        topo.execute()
                Visualization_topologies.delete().where((time.time() - Visualization_topologies.updated) > 30).execute()
                    # self.dport_id.append(str(datapath.id) + "-" + str(stat.port_no))

    def send_lldp_packet (self, datapath, port_no, hw_addr):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        timestamp = time.time()
        # print "---------------------------start--------------------------------"
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
        timestamp = time.time()
 
        pkt_ethernet = pkt.get_protocol(ethernet.ethernet)
        if not pkt_ethernet:
            return
 
        pkt_lldp = pkt.get_protocol(lldp.lldp)
        if pkt_lldp:
            self.handle_lldp(datapath, port, pkt_lldp, timestamp)
            # time_test = time.time()
            # diff = time_test - self.test_time
            # print 'db_insert_time:', diff

    def handle_lldp(self, datapath, port, pkt_lldp, timestamp):
        timestamp_diff = timestamp - pkt_lldp.tlvs[3].timestamp
        # <--- db 
        if datapath.id is not None:
            if int(datapath.id) > int(pkt_lldp.tlvs[0].chassis_id):
                sid1 = str(pkt_lldp.tlvs[0].chassis_id) + "-" + str(pkt_lldp.tlvs[1].port_id)
                sid2 = str(datapath.id) + "-" + str(port)
            else:
                sid1 = str(datapath.id) + "-" + str(port)
                sid2 = str(pkt_lldp.tlvs[0].chassis_id) + "-" + str(pkt_lldp.tlvs[1].port_id)
            
            #print sid1 + " , " + sid2
            topo = Visualization_topologies.select().where((Visualization_topologies.dport1 == sid1) & (Visualization_topologies.dport2 == sid2)) 
            if topo.exists():
                # print "update"
                # <--- db update
                if topo[0].updated == int(pkt_lldp.tlvs[3].timestamp):
                    if topo[0].delay > timestamp_diff:
                        topo = Visualization_topologies.update(delay=timestamp_diff,updated=pkt_lldp.tlvs[3].timestamp).where((Visualization_topologies.dport1 == sid1) & (Visualization_topologies.dport2 == sid2))
                        topo.execute()
                else:
                    topo = Visualization_topologies.update(delay=timestamp_diff,updated=pkt_lldp.tlvs[3].timestamp).where((Visualization_topologies.dport1 == sid1) & (Visualization_topologies.dport2 == sid2))
                    topo.execute()
                # db update --->
            else:
                # <--- db insert
                #print "insert"
                topo = Visualization_topologies.insert(dport1=sid1,dport2=sid2,delay=timestamp_diff,judge='S',updated=pkt_lldp.tlvs[3].timestamp)
                topo.execute()
                # db insert --->
            
        # <--- db delete
        Visualization_topologies.delete().where((time.time() - Visualization_topologies.updated) > 20).execute()
        # ---> db delete

    # def switch_id(self):
    #     switch = Visualization_topologies.select().where(Visualization_topologies.judge == "S")
    #     if switch.exists():
    #         for s in switch:
    #             self.dport_id.remove(s.dport1)
    #             self.dport_id.remove(s.dport2)

    # def insert_host(self):
    #     self.dport_id.sort()
    #     # self.switch_id()
    #     for j in range(len(self.dport_id)):
    #         host = Visualization_topologies.select().where(Visualization_topologies.dport1 == self.dport_id[j])
            
    #         if host.exists():
    #             #print "update"
    #             # <--- db update
    #             topo = Visualization_topologies.update(updated=time.time()).where((Visualization_topologies.dport1 == self.dport_id[j]) & (Visualization_topologies.dport2 == self.hostname[j]))
    #             topo.execute()
    #             # db update --->
    #         else:
    #             # <--- db insert
    #             #print "insert"
    #             topo = Visualization_topologies.insert(dport1=self.dport_id[j], dport2=self.hostname[j], judge='H', updated=time.time())
    #             topo.execute()
    #             # db insert --->
            
    #     self.insert_route()
    #     Visualization_topologies.delete().where((time.time() - Visualization_topologies.updated) > 10).execute()

    def insert_route(self):
        h = []
        switch = Visualization_topologies.select().where(Visualization_topologies.judge == "S")
        host = Visualization_topologies.select().where(Visualization_topologies.judge == "H")
        if host.exists() and switch.exists():
            for i in host:
                h.append(i.dport1)
                
            for element in itertools.combinations(h, 2):
                route = Visualization_route.select().where((Visualization_route.start == element[0]) & (Visualization_route.end == element[1]))
                if route.exists():
                    route_path = self.search_route(element[0],element[1], switch)
                    route = Visualization_route.update(route=route_path, updated=time.time()).where((Visualization_route.start == element[0]) & (Visualization_route.end == element[1]))
                    route.execute()
                else:
                    route_path = self.search_route(element[0],element[1], switch)
                    route = Visualization_route.insert(start=element[0], end=element[1], route=route_path, updated=time.time())
                    route.execute()
        Visualization_route.delete().where((time.time() - Visualization_topologies.updated) > 20).execute()
    
    def search_route(self, start, end, switch):
        dport = []
        start = Visualization_topologies.select().where(Visualization_topologies.dport1 == start)
        end = Visualization_topologies.select().where(Visualization_topologies.dport1 == end)
        st = start[0].dport2 + "," + start[0].dport1
        en = end[0].dport1 + "," + end[0].dport2
        d1 = start[0].dport1
        d2 = end[0].dport1
        d1.split(",")
        d2.split(",")
        if  d1[0] == d2[0] :
            route = st + "|" + en
            return route
        else:
            for s in switch:
                dport.append(s.dport1 + "," + s.dport2)
            switch_path = '|'.join(dport)
            route = st + "|" + switch_path + "|" + en
            return route

    def connection(self):
        path_switch = []
        switch = Visualization_topologies.select().where(Visualization_topologies.judge == "S")
        if switch.exists():
            for s in switch:
                path_switch.append(s.dport1)
                path_switch.append(s.dport2)
                vlans = Visualization_vlans.select()
            for v in vlans:
                i = []
                path_length = v.path_length
                path = re.split('[|,]',v.path)
                path.remove(v.start)
                path.remove(v.end)
                for p in path:
                    for ps in path_switch:
                        if p == ps:
                            i.append(ps)

                host_name1 = Visualization_topologies.get(Visualization_topologies.dport1 == v.start)
                host_name2 = Visualization_topologies.get(Visualization_topologies.dport1 == v.end)
                if  len(i) < path_length:
                    cmd = "curl -X GET http://10.50.0.101:8080/auto/" + host_name1.dport2 + "/" + host_name2.dport2 + "/" + str(v.vlanid)
                
                    subprocess.call(cmd, shell=True)