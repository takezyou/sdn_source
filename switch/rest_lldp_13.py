from ryu.app import lldp_13

from webob import Response

from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls

from ryu.app.wsgi import ControllerBase, WSGIApplication, route

from ryu.ofproto import ofproto_v1_3

from ryu.lib import dpid as dpid_lib
from ryu.lib.ofctl_utils import str_to_int
import re
import peewee

simple_switch_instance_name = 'switch_api_app'
db = peewee.MySQLDatabase("ryu_db", host="10.50.0.100", port=3306, user="root", passwd="")

class Vlans(peewee.Model):
    vlan = peewee.IntegerField(primary_key=True)
    start = peewee.CharField()
    end = peewee.CharField()
    path = peewee.CharField()

    class Meta:
        database = db # this model uses the people database


class SwitchRest13(lldp_13.Switch13):

    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]
    _CONTEXTS = {
                 'wsgi': WSGIApplication
                }

    def __init__(self, *args, **kwargs):
        super(SwitchRest13, self).__init__(*args, **kwargs)
        self.switches = {}
        self.port_list = {}
        wsgi = kwargs['wsgi']
        wsgi.register(SwitchController,
                      {simple_switch_instance_name: self})

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        super(SwitchRest13, self).switch_features_handler(ev)
        datapath = ev.msg.datapath
        self.switches[datapath.id] = datapath
        self.mac_to_port.setdefault(datapath.id, {})
    
    def set_push_pop_vlan_flow1(self, vlan, dpid, port1, port2):
        datapath = self.switches.get(000000000000000 + dpid)
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        f = parser.OFPMatchField.make(ofproto.OXM_OF_VLAN_VID, (vlan | ofproto.OFPVID_PRESENT))
        actions = [parser.OFPActionPushVlan(self.vlan_type),
                   parser.OFPActionSetField(f),
                   parser.OFPActionOutput(port2)]
        match = parser.OFPMatch(in_port=port1)
        self.add_flow(datapath, 1, match, actions)

        actions = [parser.OFPActionPopVlan(self.vlan_type),
                   parser.OFPActionOutput(port1)]
        match = parser.OFPMatch(in_port=port2, vlan_vid=(vlan | ofproto.OFPVID_PRESENT))

        self.add_flow(datapath, 1, match, actions)

    def set_push_pop_vlan_flow2(self, vlan, dpid, port1, port2):
        datapath = self.switches.get(000000000000000 + dpid)
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        f = parser.OFPMatchField.make(ofproto.OXM_OF_VLAN_VID, (vlan | ofproto.OFPVID_PRESENT))
        actions = [parser.OFPActionPushVlan(self.vlan_type),
                   parser.OFPActionSetField(f),
                   parser.OFPActionOutput(port1)]
        match = parser.OFPMatch(in_port=port2)
        self.add_flow(datapath, 1, match, actions)

        actions = [parser.OFPActionPopVlan(self.vlan_type),
                   parser.OFPActionOutput(port2)]
        match = parser.OFPMatch(in_port=port1, vlan_vid=(vlan | ofproto.OFPVID_PRESENT))

        self.add_flow(datapath, 1, match, actions)
    
    def set_vlan_flow(self, vlan, dpid, port1, port2):
        datapath = self.switches.get(000000000000000 + dpid)
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser

        actions = [parser.OFPActionOutput(port2)]
        match = parser.OFPMatch(in_port=port1, vlan_vid=(vlan | ofproto.OFPVID_PRESENT))
        self.add_flow(datapath, 1, match, actions)

        actions = [parser.OFPActionOutput(port1)]
        match = parser.OFPMatch(in_port=port2, vlan_vid=(vlan | ofproto.OFPVID_PRESENT))

        self.add_flow(datapath, 1, match, actions)


class SwitchController(ControllerBase):

    def __init__(self, req, link, data, **config):
        super(SwitchController, self).__init__(req, link, data, **config)
        self.switch_app = data[simple_switch_instance_name]

    @route('switch', '/add/{start}/{end}', methods=['GET'])
    def add_mac_table(self, req, **kwargs):
        start = kwargs['start']
        end = kwargs['end']

        s = Vlans.get(Vlans.start == start)
        e = Vlans.get(Vlans.end == end)

        if start == s.start and end == e.end:
            self.path_division(s, e)

    @route('switch', '/del/{vlan}', methods=['GET'])
    def del_mac_table(self, req, **kwargs):
        vlan = kwargs['vlan']

        v = Vlans.get(Vlans.vlan == vlan)
        s = v.start
        e = v.end
        port1 = s.split("-")
        port2 = e.split("-")

        self.switch_app.del_flow(vlan, port1[1], port2[1])
        

    @route('switch', '/modify/{start}/{end}', methods=['GET'])
    def modify_mac_table(self, req, **kwargs):
        start = kwargs['start']
        end = kwargs['end']

        s = Vlans.get(Vlan.start == start)
        e = Vlans.get(Vlan.end == end)

        self.switch_app.del_flow(s.vlan)

        if start == s.start and end == e.end:
            self.path_division(s, e)


    def path_division(self, start, end):
        vlan = start.vlan
        path = start.path
        path_list = re.split('[|,]',path)
        path_join =[]
        for i in range(len(path_list)):
            if i % 2 != 0:
                path_join.append(",".join([path_list[i-1], path_list[i]]))

        path = re.split('[,-]',path_join[0])
        self.switch_app.set_push_pop_vlan_flow1(vlan, int(path[0]), int(path[1]), int(path[3]))

        path = re.split('[,-]',path_join[-1])
        self.switch_app.set_push_pop_vlan_flow2(vlan, int(path[0]), int(path[1]), int(path[3]))

        if len(path_join) != 2:
            for j in range(1, len(path_join)-1):
                path = re.split('[,-]',path_join[j])
                self.switch_app.set_vlan_flow(vlan, int(path[0]), int(path[1]), int(path[3]))