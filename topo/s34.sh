for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s34 --protocol=OpenFlow13 | grep "patch34-$i"` ]] ; then
  ovs-vsctl del-port s34 patch34-$i
fi
done

for ((i=1 ; i<34 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s34 patch34-$i -- set interface patch34-$i type=patch options:peer=patch$i-33 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 33 ]; then
j=$((i+1))
ovs-vsctl add-port s34 patch34-$i -- set interface patch34-$i type=patch options:peer=patch$j-34 ofport=$j
fi
done