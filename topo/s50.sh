for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s50 --protocol=OpenFlow13 | grep "patch50-$i"` ]] ; then
  ovs-vsctl del-port s50 patch50-$i
fi
done

for ((i=1 ; i<50 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s50 patch50-$i -- set interface patch50-$i type=patch options:peer=patch$i-49 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 49 ]; then
j=$((i+1))
ovs-vsctl add-port s50 patch50-$i -- set interface patch50-$i type=patch options:peer=patch$j-50 ofport=$j
fi
done

