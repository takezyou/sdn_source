for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-$i"` ]] ; then
  ovs-vsctl del-port s4 patch4-$i
fi
done

for ((i=1 ; i<4 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s4 patch4-$i -- set interface patch4-$i type=patch options:peer=patch$i-3 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 3 ]; then
j=$((i+1))
ovs-vsctl add-port s4 patch4-$i -- set interface patch4-$i type=patch options:peer=patch$j-4 ofport=$j
fi
done