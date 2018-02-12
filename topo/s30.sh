for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s30 --protocol=OpenFlow13 | grep "patch30-$i"` ]] ; then
  ovs-vsctl del-port s30 patch30-$i
fi
done

for ((i=1 ; i<30 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s30 patch30-$i -- set interface patch30-$i type=patch options:peer=patch$i-29 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 29 ]; then
j=$((i+1))
ovs-vsctl add-port s30 patch30-$i -- set interface patch30-$i type=patch options:peer=patch$j-30 ofport=$j
fi
done