for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s13 --protocol=OpenFlow13 | grep "patch13-$i"` ]] ; then
  ovs-vsctl del-port s13 patch13-$i
fi
done

for ((i=1 ; i<13 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s13 patch13-$i -- set interface patch13-$i type=patch options:peer=patch$i-12 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 12 ]; then
j=$((i+1))
ovs-vsctl add-port s13 patch13-$i -- set interface patch13-$i type=patch options:peer=patch$j-13 ofport=$j
fi
done