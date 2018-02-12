for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s26 --protocol=OpenFlow13 | grep "patch26-$i"` ]] ; then
  ovs-vsctl del-port s26 patch26-$i
fi
done

for ((i=1 ; i < 26 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s26 patch26-$i -- set interface patch26-$i type=patch options:peer=patch$i-25 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 25 ]; then
j=$((i+1))
ovs-vsctl add-port s26 patch26-$i -- set interface patch26-$i type=patch options:peer=patch$j-26 ofport=$j
fi
done

