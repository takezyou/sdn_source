for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s40 --protocol=OpenFlow13 | grep "patch40-$i"` ]] ; then
  ovs-vsctl del-port s40 patch40-$i
fi
done

for ((i=1 ; i<40 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s40 patch40-$i -- set interface patch40-$i type=patch options:peer=patch$i-39 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 39 ]; then
j=$((i+1))
ovs-vsctl add-port s40 patch40-$i -- set interface patch40-$i type=patch options:peer=patch$j-40 ofport=$j
fi
done