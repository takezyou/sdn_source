for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s23 --protocol=OpenFlow13 | grep "patch23-$i"` ]] ; then
  ovs-vsctl del-port s23 patch23-$i
fi
done

for ((i=1 ; i<23 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s23 patch23-$i -- set interface patch23-$i type=patch options:peer=patch$i-22 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 22 ]; then
j=$((i+1))
ovs-vsctl add-port s23 patch23-$i -- set interface patch23-$i type=patch options:peer=patch$j-23 ofport=$j
fi
done

