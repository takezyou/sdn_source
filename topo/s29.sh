for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s29 --protocol=OpenFlow13 | grep "patch29-$i"` ]] ; then
  ovs-vsctl del-port s29 patch29-$i
fi
done

for ((i=1 ; i<29 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s29 patch29-$i -- set interface patch29-$i type=patch options:peer=patch$i-28 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 28 ]; then
j=$((i+1))
ovs-vsctl add-port s29 patch29-$i -- set interface patch29-$i type=patch options:peer=patch$j-29 ofport=$j
fi
done

