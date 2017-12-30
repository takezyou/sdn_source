from ryu.app import d_lldp_13

from webob import Response

from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls

from ryu.app.wsgi import ControllerBase, WSGIApplication, route

from ryu.ofproto import ofproto_v1_3

from ryu.lib import dpid as dpid_lib
from ryu.lib.ofctl_utils import str_to_int

import subprocess
import re
import peewee
import networkx as nx

simple_switch_instance_name = 'switch_api_app'
db = peewee.MySQLDatabase("ryu_db", host="10.50.0.100", port=3306, user="root", passwd="")

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

    class Meta:
        database = db # this model uses the people database

class Visualization_route(peewee.Model):
    id = peewee.IntegerField(primary_key=True)
    start = peewee.CharField()
    end = peewee.CharField()
    route = peewee.TextField()
    updated = peewee.IntegerField()

    class Meta:
        database = db # this model uses the people database


class SwitchRest13(d_lldp_13.Switch13):

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
        self.add_flow(datapath, 1, match, actions, vlan)

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

        s = Visualization_vlans.get(Visualization_vlans.start == start)
        e = Visualization_vlans.get(Visualization_vlans.end == end)

        if start == s.start and end == e.end:
            self.path_division(s, e)

    @route('switch', '/del/{vlan}', methods=['GET'])
    def del_mac_table(self, req, **kwargs):
        vlan = kwargs['vlan']

        v = Visualization_vlans.get(Visualization_vlans.vlanid == vlan)
        s = v.start
        e = v.end
        port1 = s.split("-")
        port2 = e.split("-")

        self.switch_app.del_flow(vlan, port1[1], port2[1])
        

    @route('switch', '/modify/{start}/{end}', methods=['GET'])
    def modify_mac_table(self, req, **kwargs):
        start = kwargs['start']
        end = kwargs['end']

        s = Visualization_vlans.get(Visualization_vlans.start == start)
        e = Visualization_vlans.get(Visualization_vlans.end == end)

        port1 = start.split("-")
        port2 = end.split("-")

        self.switch_app.del_flow(s.vlanid, port1[1], port2[1])

        if start == s.start and end == e.end:
            self.path_division(s, e)

    @route('switch', '/auto/{start}/{end}/{vlanid}', methods=['GET'])
    def auto_mac_table(self, req, **kwargs):
        start = kwargs['start']
        end = kwargs['end']
        vlan = kwargs['vlanid']
        
        vlans = Visualization_vlans.select().where((Visualization_vlans.start == start) & (Visualization_vlans.end == end))
        if vlans.exists():
            cmd = "curl -X GET http://10.50.0.100:8080/del/" + str(vlan)

        subprocess.call(cmd, shell=True)

        route = Visualization_route.select().where((Visualization_route.start == start) & (Visualization_route.end == end)) 
        if route.exists():
            self.dijkstra(route[0], vlan)


    def path_division(self, start, end):
        vlan = start.vlanid
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
    
    def dijkstra(self, path, vlan):
        path = path.route
        route_list = re.split('[|,]',path)
        path_join = []
        path_route = []
        if len(route_list) != 4: 
            path_route.append(route_list[1])
            Graph = nx.DiGraph()
            node1 = re.split('[-]',route_list[1])
            node2 = re.split('[-]',route_list[-2])
            Graph.add_nodes_from([route_list[0], node1[0]])
            Graph.add_edge(route_list[0], node1[0], weight=1)
            Graph.add_nodes_from([node2[0],route_list[-1]])
            Graph.add_edge(node2[0], route_list[-1], weight=1)

            for i in range(2,len(route_list)-2):
                if i % 2 != 0:
                    path_join.append(",".join([route_list[i-1], route_list[i]]))

            for i in range(len(path_join)):
                node_edge = re.split('[-,]',path_join[i])
                Graph.add_nodes_from([node_edge[0], node_edge[2]])
                if node1[0] == node_edge[0]:
                    Graph.add_edge(node_edge[0], node_edge[2], weight=1+1)
                else:
                    Graph.add_edge(node_edge[2], node_edge[0], weight=2+i)

            route_path = nx.dijkstra_path(Graph, source=route_list[0], target=route_list[-1])

            for i in range(len(path_join)):
                node_edge = re.split('[-,]',path_join[i])
                for j in range(len(route_path)-1):
                    print route_path[j], route_path[j+1]
                    if (node_edge[0] == route_path[j] and node_edge[2] == route_path[j+1]) or (node_edge[0] == route_path[j+1] and node_edge[2] == route_path[j]):
                        path_route.append(path_join[i])
            
            path_route.append(route_list[-2])
            print path_route
            path = "|".join(path_route)

            vlans = Visualization_vlans.select().where((Visualization_vlans.start == route_list[1]) & (Visualization_vlans.end == route_list[-2]))
            if vlans.exists():
                vlans = Visualization_vlans.update(path=path).where((Visualization_vlans.start == route_list[1]) & (Visualization_vlans.end == route_list[-2]))
                vlans.execute()

                cmd = "curl -X GET http://10.50.0.100:8080/add/" + route_list[1] + "/" + route_list[-2]

                subprocess.call(cmd, shell=True)
            else:
                vlans = Visualization_vlans.insert(vlanid=vlan,start=route_list[1], end=route_list[-2], path=path)
                vlans.execute()

                cmd = "curl -X GET http://10.50.0.100:8080/add/" + route_list[1] +  "/"  +route_list[-2]

                subprocess.call(cmd, shell=True)

        else:
            vlans = Visualization_vlans.select().where((Visualization_vlans.start == route_list[1]) & (Visualization_vlans.end == route_list[-2]))
            if vlans.exists():
                path = "|".join([route_list[1],route_list[-2]])
                vlans = Visualization_vlans.update(path=path).where((Visualization_vlans.start == route_list[1]) & (Visualization_vlans.end == route_list[-2]))
                vlans.execute()

                cmd = "curl -X GET http://10.50.0.100:8080/add/" + route_list[1] + "/" + route_list[-2]

                subprocess.call(cmd, shell=True)
            else:
                path = "|".join([route_list[1],route_list[-2]])
                vlans = Visualization_vlans.insert(vlanid=vlan,start=route_list[1], end=route_list[-2], path=path)
                vlans.execute()

                cmd = "curl -X GET http://10.50.0.100:8080/add/" + route_list[1] + "/" + route_list[-2]

                subprocess.call(cmd, shell=True)