for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-$i"` ]] ; then
  ovs-vsctl del-port s10 patch10-$i
fi
done

for ((i=1 ; i<10 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s10 patch10-$i -- set interface patch10-$i type=patch options:peer=patch$i-9 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 9 ]; then
j=$((i+1))
ovs-vsctl add-port s10 patch10-$i -- set interface patch10-$i type=patch options:peer=patch$j-10 ofport=$j
fi
done