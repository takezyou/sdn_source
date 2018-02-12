for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s46 --protocol=OpenFlow13 | grep "patch46-$i"` ]] ; then
  ovs-vsctl del-port s46 patch46-$i
fi
done

for ((i=1 ; i<46 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s46 patch46-$i -- set interface patch46-$i type=patch options:peer=patch$i-45 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 45 ]; then
j=$((i+1))
ovs-vsctl add-port s46 patch46-$i -- set interface patch46-$i type=patch options:peer=patch$j-46 ofport=$j
fi
done