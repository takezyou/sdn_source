for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-$i"` ]] ; then
  ovs-vsctl del-port s8 patch8-$i
fi
done

for ((i=1 ; i<8 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s8 patch8-$i -- set interface patch8-$i type=patch options:peer=patch$i-7 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 7 ]; then
j=$((i+1))
ovs-vsctl add-port s8 patch8-$i -- set interface patch8-$i type=patch options:peer=patch$j-8 ofport=$j
fi
done