for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s15 --protocol=OpenFlow13 | grep "patch15-$i"` ]] ; then
  ovs-vsctl del-port s15 patch15-$i
fi
done

for ((i=1 ; i<15 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s15 patch15-$i -- set interface patch15-$i type=patch options:peer=patch$i-14 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 14 ]; then
j=$((i+1))
ovs-vsctl add-port s15 patch15-$i -- set interface patch15-$i type=patch options:peer=patch$j-15 ofport=$j
fi
done

