for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s43 --protocol=OpenFlow13 | grep "patch43-$i"` ]] ; then
  ovs-vsctl del-port s43 patch43-$i
fi
done

for ((i=1 ; i<43 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s43 patch43-$i -- set interface patch43-$i type=patch options:peer=patch$i-42 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 42 ]; then
j=$((i+1))
ovs-vsctl add-port s43 patch43-$i -- set interface patch43-$i type=patch options:peer=patch$j-43 ofport=$j
fi
done