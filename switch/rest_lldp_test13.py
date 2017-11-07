from ryu.app import lldp_13

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

class SwitchRest13(lldp_13.Switch13):

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
    
class SwitchController(ControllerBase):

    def __init__(self, req, link, data, **config):
        super(SwitchController, self).__init__(req, link, data, **config)
        self.simple_switch_app = data[simple_switch_instance_name]

    @route('switch', '/add/{start}/{end}', methods=['GET'])
    def add_mac_table(self, req, **kwargs):
        return

    @route('switch', '/del/{vlan}', methods=['GET'])
    def del_mac_table(self, req, **kwargs):
        return

    @route('switch', '/modify/{start}/{end}', methods=['GET'])
    def modify_mac_table(self, req, **kwargs):
        return