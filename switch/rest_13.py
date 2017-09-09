from ryu.app import switch_13

from webob import Response

from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls

from ryu.app.wsgi import ControllerBase, WSGIApplication, route

from ryu.ofproto import ofproto_v1_3

from ryu.lib import dpid as dpid_lib
from ryu.lib.ofctl_utils import str_to_int
import peewee


simple_switch_instance_name = 'switch_api_app'
flg = 1
db1 = peewee.SqliteDatabase("/root/data.db")
db2 = peewee.SqliteDatabase("/root/data1.db")

class Route(peewee.Model):
    id = peewee.IntegerField()
    hostname1 = peewee.IntegerField()
    hostname2 = peewee.IntegerField()
    flg = peewee.IntegerField()

    class Meta:
        database = db1

class Flow(peewee.Model):
    id = peewee.IntegerField()
    route_id = peewee.IntegerField()
    in_port1 = peewee.IntegerField()
    vlan1 = peewee.IntegerField()
    out_port1 = peewee.IntegerField()
    in_port2 = peewee.IntegerField()
    vlan2 = peewee.IntegerField()
    out_port2 = peewee.IntegerField()

    class Meta:
        database = db2

class SwitchRest13(switch_13.Switch13):

    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]
    _CONTEXTS = {
                 'wsgi': WSGIApplication
                }

    def __init__(self, *args, **kwargs):
        super(SwitchRest13, self).__init__(*args, **kwargs)
        self.switches = {}
        wsgi = kwargs['wsgi']
        wsgi.register(SwitchController,
                      {simple_switch_instance_name: self})

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        super(SwitchRest13, self).switch_features_handler(ev)
        datapath = ev.msg.datapath
        self.switches[datapath.id] = datapath
        self.mac_to_port.setdefault(datapath.id, {})
    
    def get_flow(self, in_port1, vlan1, out_port1, in_port2, vlan2, out_port2):
        datapath1 = self.switches.get(0000000000000001)
        datapath2 = self.switches.get(0000000000000002)
        datapath3 = self.switches.get(0000000000000003)
        ofproto1 = datapath1.ofproto
        ofproto2 = datapath2.ofproto
        ofproto3 = datapath3.ofproto
        parser1 = datapath1.ofproto_parser
        parser2 = datapath2.ofproto_parser
        parser3 = datapath3.ofproto_parser

        if datapath1.id == 1:
            actions = [parser1.OFPActionOutput(out_port1)]
            match = parser1.OFPMatch(in_port=in_port1, vlan_vid=(vlan1 | ofproto1.OFPVID_PRESENT))

            self.del_flow(datapath1, 1, match, actions)

            actions = [parser1.OFPActionOutput(in_port1)]
            match = parser1.OFPMatch(in_port=out_port1, vlan_vid=(vlan1 | ofproto1.OFPVID_PRESENT))

            self.del_flow(datapath1, 1, match, actions)
        
        if datapath2.id == 2:
            actions = [parser2.OFPActionOutput(in_port1)]
            match = parser2.OFPMatch(in_port=out_port1, vlan_vid=(vlan1 | ofproto2.OFPVID_PRESENT))

            self.del_flow(datapath2, 1, match, actions)

            actions = [parser2.OFPActionOutput(out_port1)]
            match = parser2.OFPMatch(in_port=in_port1, vlan_vid=(vlan1 | ofproto2.OFPVID_PRESENT))

            self.del_flow(datapath2, 1, match, actions)
        
        if datapath3.id == 3:
            actions = [parser3.OFPActionOutput(out_port2)]
            match = parser3.OFPMatch(in_port=in_port2, vlan_vid=(vlan2 | ofproto3.OFPVID_PRESENT))

            self.del_flow(datapath3, 1, match, actions)

            actions = [parser3.OFPActionOutput(in_port2)]
            match = parser3.OFPMatch(in_port=out_port2, vlan_vid=(vlan2 | ofproto3.OFPVID_PRESENT))

            self.del_flow(datapath3, 1, match, actions)

    def set1_flow(self, in_port1, vlan1, out_port1):
        datapath1 = self.switches.get(0000000000000001)
        datapath2 = self.switches.get(0000000000000002)
        ofproto1 = datapath1.ofproto
        ofproto2 = datapath2.ofproto
        parser1 = datapath1.ofproto_parser
        parser2 = datapath2.ofproto_parser
        
        if datapath1.id == 1:
            actions = [parser1.OFPActionOutput(out_port1)]
            match = parser1.OFPMatch(in_port=in_port1, vlan_vid=(vlan1 | ofproto1.OFPVID_PRESENT))

            self.add_flow(datapath1, 1, match, actions)

            actions = [parser1.OFPActionOutput(in_port1)]
            match = parser1.OFPMatch(in_port=out_port1, vlan_vid=(vlan1 | ofproto1.OFPVID_PRESENT))

            self.add_flow(datapath1, 1, match, actions)
        
        if datapath2.id == 2:
            actions = [parser2.OFPActionOutput(in_port1)]
            match = parser2.OFPMatch(in_port=out_port1, vlan_vid=(vlan1 | ofproto2.OFPVID_PRESENT))

            self.add_flow(datapath2, 1, match, actions)

            actions = [parser2.OFPActionOutput(out_port1)]
            match = parser2.OFPMatch(in_port=in_port1, vlan_vid=(vlan1 | ofproto2.OFPVID_PRESENT))

            self.add_flow(datapath2, 1, match, actions)
        
    def set2_flow(self, in_port1, vlan1, out_port1, in_port2, vlan2, out_port2):
        datapath1 = self.switches.get(0000000000000001)
        datapath2 = self.switches.get(0000000000000002)
        datapath3 = self.switches.get(0000000000000003)
        ofproto1 = datapath1.ofproto
        ofproto2 = datapath2.ofproto
        ofproto3 = datapath3.ofproto
        parser1 = datapath1.ofproto_parser
        parser2 = datapath2.ofproto_parser
        parser3 = datapath3.ofproto_parser

        if datapath1.id == 1:
            actions = [parser1.OFPActionOutput(out_port1)]
            match = parser1.OFPMatch(in_port=in_port1, vlan_vid=(vlan1 | ofproto1.OFPVID_PRESENT))

            self.add_flow(datapath1, 1, match, actions)

            actions = [parser1.OFPActionOutput(in_port1)]
            match = parser1.OFPMatch(in_port=out_port1, vlan_vid=(vlan1 | ofproto1.OFPVID_PRESENT))

            self.add_flow(datapath1, 1, match, actions)
        
        if datapath2.id == 2:
            actions = [parser2.OFPActionOutput(in_port1)]
            match = parser2.OFPMatch(in_port=out_port1, vlan_vid=(vlan1 | ofproto2.OFPVID_PRESENT))

            self.add_flow(datapath2, 1, match, actions)

            actions = [parser2.OFPActionOutput(out_port1)]
            match = parser2.OFPMatch(in_port=in_port1, vlan_vid=(vlan1 | ofproto2.OFPVID_PRESENT))

            self.add_flow(datapath2, 1, match, actions)
        
        if datapath3.id == 3:
            actions = [parser3.OFPActionOutput(out_port2)]
            match = parser3.OFPMatch(in_port=in_port2, vlan_vid=(vlan2 | ofproto3.OFPVID_PRESENT))

            self.add_flow(datapath3, 1, match, actions)

            actions = [parser3.OFPActionOutput(in_port2)]
            match = parser3.OFPMatch(in_port=out_port2, vlan_vid=(vlan2 | ofproto3.OFPVID_PRESENT))

            self.add_flow(datapath3, 1, match, actions)
        
    def flg_update(self, hostname):
        route1 = Route.get(Route.hostname1 == hostname)
        route2 = Route.get(Route.hostname1 == hostname)

        if route1.flg == 1:
            route1.flg = 0
            route1.save()
        elif route1.flg == 0:
            route1.flg = 1
            route1.save()
        if route2.flg == 1:
            route2.flg = 0
            route2.save()
        elif route2.flg == 0:
            route2.flg = 1
            route2.save()
    
class SwitchController(ControllerBase):

    def __init__(self, req, link, data, **config):
        super(SwitchController, self).__init__(req, link, data, **config)
        self.simple_switch_app = data[simple_switch_instance_name]

    @route('switch', '/add/{hostname1}/{hostname2}', methods=['GET'])
    def add_mac_table(self, req, **kwargs):
        simple_switch = self.simple_switch_app
        hostname1 = str_to_int(kwargs['hostname1'])
        hostname2 = str_to_int(kwargs['hostname2'])
        route = Route.get(Route.hostname1 == hostname1)

        if hostname1 == route.hostname1 and hostname2 == route.hostname2:
            flow = Flow.filter(Flow.route_id == 1).execute()
            for f in flow:
                    simple_switch.get_flow(f.in_port1, f.vlan1, f.out_port1, f.in_port2, f.vlan2, f.out_port2)
            
            for f in flow:
                if f.in_port1 != 4 and route.flg != 0:
                        simple_switch.set2_flow(f.in_port1, f.vlan1, f.out_port1, f.in_port2, f.vlan2, f.out_port2)
                elif f.in_port1 != 3 and route.flg != 1:
                        simple_switch.set1_flow(f.in_port1, f.vlan1, f.out_port1)
            
            simple_switch.flg_update(hostname1)