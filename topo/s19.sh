for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s19 --protocol=OpenFlow13 | grep "patch19-$i"` ]] ; then
  ovs-vsctl del-port s19 patch19-$i
fi
done


for ((i=1 ; i<19 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s19 patch19-$i -- set interface patch19-$i type=patch options:peer=patch$i-18 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 18 ]; then
j=$((i+1))
ovs-vsctl add-port s19 patch19-$i -- set interface patch19-$i type=patch options:peer=patch$j-19 ofport=$j
fi
done
