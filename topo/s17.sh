for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s17 --protocol=OpenFlow13 | grep "patch17-$i"` ]] ; then
  ovs-vsctl del-port s17 patch17-$i
fi
done

for ((i=1 ; i<17 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s17 patch17-$i -- set interface patch17-$i type=patch options:peer=patch$i-16 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 16 ]; then
j=$((i+1))
ovs-vsctl add-port s17 patch17-$i -- set interface patch17-$i type=patch options:peer=patch$j-17 ofport=$j
fi
done

