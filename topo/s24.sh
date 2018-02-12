for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s24 --protocol=OpenFlow13 | grep "patch24-$i"` ]] ; then
  ovs-vsctl del-port s24 patch24-$i
fi
done

for ((i=1 ; i<24 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s24 patch24-$i -- set interface patch24-$i type=patch options:peer=patch$i-23 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 23 ]; then
j=$((i+1))
ovs-vsctl add-port s24 patch24-$i -- set interface patch24-$i type=patch options:peer=patch$j-24 ofport=$j
fi
done
