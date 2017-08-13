import json

from ryu.app import switch_13
from webob import Response
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.app.wsgi import ControllerBase, WSGIApplication, route
from ryu.lib import dpid as dpid_lib
from ryu.lib.ofctl_utils import str_to_int
import peewee


simple_switch_instance_name = 'switch_api_app'
db = peewee.SqliteDatabase("/root/data.db")

class Flow(peewee.Model):
    in_port = peewee.IntegerField()
    mac_address = peewee.TextField()
    out_port = peewee.IntegerField()
    datapath = peewee.TextField()
    
    class Meta:
        database = db

class SwitchRest13(switch_13.Switch13):

    _CONTEXTS = {'wsgi': WSGIApplication}

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
    
    def set_flow(self, dpid, in_port, mac_address, out_port):
        datapath = self.switches.get(dpid)
        parser = datapath.ofproto_parser

        actions = [parser.OFPActionOutput(out_port)]
        match = parser.OFPMatch(in_port=in_port, eth_dst=mac_address)

        self.add_flow(datapath, 1, match, actions)

        return 
    
class SwitchController(ControllerBase):

    def __init__(self, req, link, data, **config):
        super(SwitchController, self).__init__(req, link, data, **config)
        self.simple_switch_app = data[simple_switch_instance_name]

    @route('switch', '/add/{in_port}', methods=['GET'])
    def add_mac_table(self, req, **kwargs):

        simple_switch = self.simple_switch_app
        in_port = str_to_int(kwargs['in_port'])

        flow = Flow.get(Flow.in_port == in_port)
        dpid = dpid_lib.str_to_dpid(flow.datapath)

        if dpid not in simple_switch.mac_to_port:
            return Response(status=404)

        return simple_switch.set_flow(dpid, flow.in_port, flow.mac_address, flow.out_port)