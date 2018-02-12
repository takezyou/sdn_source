for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s16 --protocol=OpenFlow13 | grep "patch16-$i"` ]] ; then
  ovs-vsctl del-port s16 patch16-$i
fi
done

for ((i=1 ; i<16 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s16 patch16-$i -- set interface patch16-$i type=patch options:peer=patch$i-15 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 15 ]; then
j=$((i+1))
ovs-vsctl add-port s16 patch16-$i -- set interface patch16-$i type=patch options:peer=patch$j-16 ofport=$j
fi
done