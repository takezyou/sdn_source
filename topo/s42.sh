for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s42 --protocol=OpenFlow13 | grep "patch42-$i"` ]] ; then
  ovs-vsctl del-port s42 patch42-$i
fi
done

for ((i=1 ; i<42 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s42 patch42-$i -- set interface patch42-$i type=patch options:peer=patch$i-41 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 41 ]; then
j=$((i+1))
ovs-vsctl add-port s42 patch42-$i -- set interface patch42-$i type=patch options:peer=patch$j-42 ofport=$j
fi
done