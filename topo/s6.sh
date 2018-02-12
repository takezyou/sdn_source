for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-$i"` ]] ; then
  ovs-vsctl del-port s6 patch6-$i
fi
done

for ((i=1 ; i<6 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s6 patch6-$i -- set interface patch6-$i type=patch options:peer=patch$i-5 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 5 ]; then
j=$((i+1))
ovs-vsctl add-port s6 patch6-$i -- set interface patch6-$i type=patch options:peer=patch$j-6 ofport=$j
fi
done
