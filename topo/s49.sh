for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s49 --protocol=OpenFlow13 | grep "patch49-$i"` ]] ; then
  ovs-vsctl del-port s49 patch49-$i
fi
done

for ((i=1 ; i<49 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s49 patch49-$i -- set interface patch49-$i type=patch options:peer=patch$i-48 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 48 ]; then
j=$((i+1))
ovs-vsctl add-port s49 patch49-$i -- set interface patch49-$i type=patch options:peer=patch$j-49 ofport=$j
fi
done