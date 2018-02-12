for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s36 --protocol=OpenFlow13 | grep "patch36-$i"` ]] ; then
  ovs-vsctl del-port s36 patch36-$i
fi
done

for ((i=1 ; i<36 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s36 patch36-$i -- set interface patch36-$i type=patch options:peer=patch$i-35 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 35 ]; then
j=$((i+1))
ovs-vsctl add-port s36 patch36-$i -- set interface patch36-$i type=patch options:peer=patch$j-36 ofport=$j
fi
done
