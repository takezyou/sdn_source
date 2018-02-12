for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s47 --protocol=OpenFlow13 | grep "patch47-$i"` ]] ; then
  ovs-vsctl del-port s47 patch47-$i
fi
done

for ((i=1 ; i<47 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s47 patch47-$i -- set interface patch47-$i type=patch options:peer=patch$i-46 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 46 ]; then
j=$((i+1))
ovs-vsctl add-port s47 patch47-$i -- set interface patch47-$i type=patch options:peer=patch$j-47 ofport=$j
fi
done
