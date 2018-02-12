for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s41 --protocol=OpenFlow13 | grep "patch41-$i"` ]] ; then
  ovs-vsctl del-port s41 patch41-$i
fi
done

for ((i=1 ; i<41 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s41 patch41-$i -- set interface patch41-$i type=patch options:peer=patch$i-40 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 40 ]; then
j=$((i+1))
ovs-vsctl add-port s41 patch41-$i -- set interface patch41-$i type=patch options:peer=patch$j-41 ofport=$j
fi
done