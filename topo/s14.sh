for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s14 --protocol=OpenFlow13 | grep "patch14-$i"` ]] ; then
  ovs-vsctl del-port s14 patch14-$i
fi
done

for ((i=1 ; i<14 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s14 patch14-$i -- set interface patch14-$i type=patch options:peer=patch$i-13 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 13 ]; then
j=$((i+1))
ovs-vsctl add-port s14 patch14-$i -- set interface patch14-$i type=patch options:peer=patch$j-14 ofport=$j
fi
done
