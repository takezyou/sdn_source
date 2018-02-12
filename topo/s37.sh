for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s37 --protocol=OpenFlow13 | grep "patch37-$i"` ]] ; then
  ovs-vsctl del-port s37 patch37-$i
fi
done

for ((i=1 ; i<37 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s37 patch37-$i -- set interface patch37-$i type=patch options:peer=patch$i-36 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 36 ]; then
j=$((i+1))
ovs-vsctl add-port s37 patch37-$i -- set interface patch37-$i type=patch options:peer=patch$j-37 ofport=$j
fi
done

