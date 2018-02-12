for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s44 --protocol=OpenFlow13 | grep "patch44-$i"` ]] ; then
  ovs-vsctl del-port s44 patch44-$i
fi
j=$((i+1))
if  [ $i -gt 43 ]; then
j=$((i+1))
ovs-vsctl add-port s44 patch44-$i -- set interface patch44-$i type=patch options:peer=patch$j-44 ofport=$j
fi
done

for ((i=1 ; i<44 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s44 patch44-$i -- set interface patch44-$i type=patch options:peer=patch$i-43 ofport=$j