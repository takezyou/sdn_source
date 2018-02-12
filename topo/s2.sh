for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-$i"` ]] ; then
  ovs-vsctl del-port s2 patch2-$i
fi
if  [ $i -eq 1 ]; then
ovs-vsctl add-port s2 patch2-1 -- set interface patch2-1 type=patch options:peer=patch1-1 ofport=2
else
j=$((i+1 ))
ovs-vsctl add-port s2 patch2-$i -- set interface patch2-$i type=patch options:peer=patch$j-2 ofport=$j
fi
done