for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s12 --protocol=OpenFlow13 | grep "patch12-$i"` ]] ; then
  ovs-vsctl del-port s12 patch12-$i
fi
done

for ((i=1 ; i<12 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s12 patch12-$i -- set interface patch12-$i type=patch options:peer=patch$i-11 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 11 ]; then
j=$((i+1))
ovs-vsctl add-port s12 patch12-$i -- set interface patch12-$i type=patch options:peer=patch$j-12 ofport=$j
fi
done

