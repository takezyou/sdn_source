for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s38 --protocol=OpenFlow13 | grep "patch38-$i"` ]] ; then
  ovs-vsctl del-port s38 patch38-$i
fi
done

for ((i=1 ; i<38 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s38 patch38-$i -- set interface patch38-$i type=patch options:peer=patch$i-37 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 37 ]; then
j=$((i+1))
ovs-vsctl add-port s38 patch38-$i -- set interface patch38-$i type=patch options:peer=patch$j-38 ofport=$j
fi
done