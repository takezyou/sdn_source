for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s18 --protocol=OpenFlow13 | grep "patch18-$i"` ]] ; then
  ovs-vsctl del-port s18 patch18-$i
fi
done

for ((i=1 ; i<18 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s18 patch18-$i -- set interface patch18-$i type=patch options:peer=patch$i-17 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 17 ]; then
j=$((i+1))
ovs-vsctl add-port s18 patch18-$i -- set interface patch18-$i type=patch options:peer=patch$j-18 ofport=$j
fi
done