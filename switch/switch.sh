if [[ `ovs-ofctl show s$1 --protocol=OpenFlow13 | grep "patch$1-1"` ]] ; then
ovs-vsctl del-port s$1 patch$1-1
fi
if [[ `ovs-ofctl show s$1 --protocol=OpenFlow13 | grep "patch$1-2"` ]] ; then
ovs-vsctl del-port s$1 patch$1-2
fi
ovs-vsctl add-port s$1 patch$1-1 -- set interface patch$1-1 type=patch options:peer=patch$2-$1
ovs-vsctl add-port s$1 patch$1-2 -- set interface patch$1-2 type=patch options:peer=patch$3-$1
 
if [[ `ovs-ofctl show s$2 --protocol=OpenFlow13 | grep "patch$2-$1"` ]] ; then
ovs-vsctl del-port s$2 patch$2-$1
fi
if [[ `ovs-ofctl show s$3 --protocol=OpenFlow13 | grep "patch$3-$1"` ]] ; then
ovs-vsctl del-port s$3 patch$3-$1
fi
ovs-vsctl add-port s$2 patch$2-$1 -- set interface patch$2-$1 type=patch options:peer=patch$1-1
ovs-vsctl add-port s$3 patch$3-$1 -- set interface patch$3-$1 type=patch options:peer=patch$1-2
