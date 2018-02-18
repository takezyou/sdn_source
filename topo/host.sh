if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "host1"` ]] ; then
  ovs-vsctl del-port s1 host1
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "host2"` ]] ; then
  ovs-vsctl del-port s2 host2
fi
ovs-vsctl add-port s1 host1 -- set interface host1 ofport=1
ovs-vsctl add-port s2 host2 -- set interface host2 ofport=1
#
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "host3"` ]] ; then
  ovs-vsctl del-port s3 host3
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "host4"` ]] ; then
  ovs-vsctl del-port s4 host4
fi
ovs-vsctl add-port s3 host3 -- set interface host3 ofport=1
ovs-vsctl add-port s4 host4 -- set interface host4 ofport=1