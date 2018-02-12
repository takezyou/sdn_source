for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s32 --protocol=OpenFlow13 | grep "patch32-$i"` ]] ; then
  ovs-vsctl del-port s32 patch32-$i
fi
done

for ((i=1 ; i<32 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s32 patch32-$i -- set interface patch32-$i type=patch options:peer=patch$i-31 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 31 ]; then
j=$((i+1))
ovs-vsctl add-port s32 patch32-$i -- set interface patch32-$i type=patch options:peer=patch$j-32 ofport=$j
fi
done