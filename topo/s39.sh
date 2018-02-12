for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s39 --protocol=OpenFlow13 | grep "patch39-$i"` ]] ; then
  ovs-vsctl del-port s39 patch39-$i
fi
done

for ((i=1 ; i<39 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s39 patch39-$i -- set interface patch39-$i type=patch options:peer=patch$i-38 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 38 ]; then
j=$((i+1))
ovs-vsctl add-port s39 patch39-$i -- set interface patch39-$i type=patch options:peer=patch$j-39 ofport=$j
fi
done