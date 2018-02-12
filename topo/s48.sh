for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s48 --protocol=OpenFlow13 | grep "patch48-$i"` ]] ; then
  ovs-vsctl del-port s48 patch48-$i
fi
done

for ((i=1 ; i<48 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s48 patch48-$i -- set interface patch48-$i type=patch options:peer=patch$i-47 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 47 ]; then
j=$((i+1))
ovs-vsctl add-port s48 patch48-$i -- set interface patch48-$i type=patch options:peer=patch$j-48 ofport=$j
fi
done