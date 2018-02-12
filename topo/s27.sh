for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s27 --protocol=OpenFlow13 | grep "patch27-$i"` ]] ; then
  ovs-vsctl del-port s27 patch27-$i
fi
done

for ((i=1 ; i<27 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s27 patch27-$i -- set interface patch27-$i type=patch options:peer=patch$i-26 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 26 ]; then
j=$((i+1))
ovs-vsctl add-port s27 patch27-$i -- set interface patch27-$i type=patch options:peer=patch$j-27 ofport=$j
fi
done
