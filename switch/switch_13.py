from ryu.base import app_manager

from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER
from ryu.controller.handler import set_ev_cls

from ryu.ofproto import ofproto_v1_3
from ryu.ofproto import ether
from ryu.ofproto import inet

from ryu.lib.packet import packet
from ryu.lib.packet import ipv4
from ryu.lib.packet import vlan
from ryu.lib.packet import ethernet


class Switch13(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(Switch13, self).__init__(*args, **kwargs)
        # initialize mac address table.
        self.mac_to_port = {}

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        datapath = ev.msg.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        dpid = datapath.id
        if dpid == 1:
            actions = [parser.OFPActionOutput(1)]
            match = parser.OFPMatch(in_port=4, vlan_vid=(10 | ofproto.OFPVID_PRESENT))

            self.add_flow(datapath, 1, match, actions)

            actions = [parser.OFPActionOutput(4)]
            match = parser.OFPMatch(in_port=1, vlan_vid=(10 | ofproto.OFPVID_PRESENT))

            self.add_flow(datapath, 1, match, actions)
        
        if dpid == 2:
            actions = [parser.OFPActionOutput(1)]
            match = parser.OFPMatch(in_port=4, vlan_vid=(10 | ofproto.OFPVID_PRESENT))

            self.add_flow(datapath, 1, match, actions)

            actions = [parser.OFPActionOutput(4)]
            match = parser.OFPMatch(in_port=1, vlan_vid=(10 | ofproto.OFPVID_PRESENT))

            self.add_flow(datapath, 1, match, actions)

    def add_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # construct flow_mod message and send it.
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,
                                             actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                match=match, instructions=inst)
        datapath.send_msg(mod)

    def del_flow(self, datapath, priority, match, actions):
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        # construct flow_mod message and send it.
        inst = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS, actions)]
        mod = parser.OFPFlowMod(datapath=datapath, priority=priority,
                                command=ofproto.OFPFC_DELETE_STRICT, out_port=ofproto.OFPP_ANY, out_group=ofproto.OFPG_ANY, match=match, instructions=inst)
        datapath.send_msg(mod)