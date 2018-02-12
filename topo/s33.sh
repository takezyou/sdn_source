for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s33 --protocol=OpenFlow13 | grep "patch33-$i"` ]] ; then
  ovs-vsctl del-port s33 patch33-$i
fi
done

for ((i=1 ; i<33 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s33 patch33-$i -- set interface patch33-$1 type=patch options:peer=patch$i-32 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 32 ]; then
j=$((i+1))
ovs-vsctl add-port s33 patch33-$i -- set interface patch33-$i type=patch options:peer=patch$j-33 ofport=$j
fi
done

