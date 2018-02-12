
for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s11 --protocol=OpenFlow13 | grep "patch11-$i"` ]] ; then
  ovs-vsctl del-port s11 patch11-$i
fi
done

for ((i=1 ; i<11 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s11 patch11-$i -- set interface patch11-$i type=patch options:peer=patch$i-10 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 10 ]; then
j=$((i+1))
ovs-vsctl add-port s11 patch11-$i -- set interface patch11-$i type=patch options:peer=patch$j-11 ofport=$j
fi
done

