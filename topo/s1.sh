for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-$i"` ]] ; then
  ovs-vsctl del-port s1 patch1-$i
fi
j=$((i+1))
ovs-vsctl add-port s1 patch1-$i -- set interface patch1-$i type=patch options:peer=patch$j-1 ofport=$j
done

