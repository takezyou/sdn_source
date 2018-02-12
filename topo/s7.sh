for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-$i"` ]] ; then
  ovs-vsctl del-port s7 patch7-$i
fi
done

for ((i=1 ; i<7 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s7 patch7-$i -- set interface patch7-$i type=patch options:peer=patch$i-6 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 6 ]; then
j=$((i+1))
ovs-vsctl add-port s7 patch7-$i -- set interface patch7-$i type=patch options:peer=patch$j-7 ofport=$j
fi
done