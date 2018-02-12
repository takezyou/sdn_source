for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-$i"` ]] ; then
  ovs-vsctl del-port s9 patch9-$i
fi
done

for ((i=1 ; i<9 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s9 patch9-$i -- set interface patch9-$i type=patch options:peer=patch$i-8 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 8 ]; then
j=$((i+1))
ovs-vsctl add-port s9 patch9-$i -- set interface patch9-$i type=patch options:peer=patch$j-9 ofport=$j
fi
done