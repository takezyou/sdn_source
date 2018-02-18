for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s45 --protocol=OpenFlow13 | grep "patch45-$i"` ]] ; then
  ovs-vsctl del-port s45 patch45-$i
fi
done

for ((i=1 ; i<45 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s45 patch45-$i -- set interface patch45-$i type=patch options:peer=patch$i-44 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 44 ]; then
j=$((i+1))
ovs-vsctl add-port s45 patch45-$i -- set interface patch45-$i type=patch options:peer=patch$j-45 ofport=$j
fi
done

