for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s28 --protocol=OpenFlow13 | grep "patch28-$i"` ]] ; then
  ovs-vsctl del-port s28 patch28-$i
fi
done

for ((i=1 ; i<28 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s28 patch28-$i -- set interface patch28-$i type=patch options:peer=patch$i-27 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 27 ]; then
j=$((i+1))
ovs-vsctl add-port s28 patch28-$i -- set interface patch28-$i type=patch options:peer=patch$j-28 ofport=$j
fi
done

