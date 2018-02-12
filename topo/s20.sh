for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s20 --protocol=OpenFlow13 | grep "patch20-$i"` ]] ; then
  ovs-vsctl del-port s20 patch20-$i
fi
done

for ((i=1 ; i<20 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s20 patch20-$i -- set interface patch20-$i type=patch options:peer=patch$i-19 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 19 ]; then
j=$((i+1))
ovs-vsctl add-port s20 patch20-$i -- set interface patch20-$i type=patch options:peer=patch$j-20 ofport=$j
fi
done