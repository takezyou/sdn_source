for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-$i"` ]] ; then
  ovs-vsctl del-port s5 patch5-$i
fi
done

for ((i=1 ; i<5 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s5 patch5-$i -- set interface patch5-$i type=patch options:peer=patch$i-4 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 4 ]; then
j=$((i+1))
ovs-vsctl add-port s5 patch5-$i -- set interface patch5-$i type=patch options:peer=patch$j-5 ofport=$j
fi
done
