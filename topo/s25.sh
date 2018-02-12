for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s25 --protocol=OpenFlow13 | grep "patch25-$i"` ]] ; then
  ovs-vsctl del-port s25 patch25-$i
fi
done

for ((i=1 ; i<25 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s25 patch25-$i -- set interface patch25-$i type=patch options:peer=patch$i-24 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 24 ]; then
j=$((i+1))
ovs-vsctl add-port s25 patch25-$i -- set interface patch25-$i type=patch options:peer=patch$j-25 ofport=$j
fi
done

