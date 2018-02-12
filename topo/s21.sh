for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s21 --protocol=OpenFlow13 | grep "patch21-$i"` ]] ; then
  ovs-vsctl del-port s21 patch21-$i
fi
done

for ((i=1 ; i<21 ; i++))
do
j=$((i+1))
ovs-vsctl add-port s21 patch21-$i -- set interface patch21-$i type=patch options:peer=patch$i-20 ofport=$j
done

for i in `seq 1 $1`
do
j=$((i+1))
if  [ $i -gt 20 ]; then
j=$((i+1))
ovs-vsctl add-port s21 patch21-$i -- set interface patch21-$i type=patch options:peer=patch$j-21 ofport=$j
fi
done

