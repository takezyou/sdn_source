for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s31 --protocol=OpenFlow13 | grep "patch31-$i"` ]] ; then
  ovs-vsctl del-port s31 patch31-$i
fi
done

for ((i=1 ; i<31 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s31 patch31-$i -- set interface patch31-$i type=patch options:peer=patch$i-30 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 30 ]; then
j=$((i+1))
ovs-vsctl add-port s31 patch31-$i -- set interface patch31-$i type=patch options:peer=patch$j-31 ofport=$j
fi
done

