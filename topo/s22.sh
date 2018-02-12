for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s22 --protocol=OpenFlow13 | grep "patch22-$i"` ]] ; then
  ovs-vsctl del-port s22 patch22-$i
fi
done

for ((i=1 ; i<22 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s22 patch22-$i -- set interface patch22-$i type=patch options:peer=patch$i-21 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 21 ]; then
j=$((i+1))
ovs-vsctl add-port s22 patch22-$i -- set interface patch22-$i type=patch options:peer=patch$j-22 ofport=$j
fi
done
