for i in `seq 1 $1`
do
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-$i"` ]] ; then
  ovs-vsctl del-port s3 patch3-$i
fi
if  [ $i -eq 1 ]; then
j=$((i+1))
ovs-vsctl add-port s3 patch3-1 -- set interface patch3-1 type=patch options:peer=patch1-2 ofport=2
elif  [ $i -eq 2 ]; then
j=$((i+1))
ovs-vsctl add-port s3 patch3-2 -- set interface patch3-2 type=patch options:peer=patch2-2 ofport=3
else
j=$((i+1))
ovs-vsctl add-port s3 patch3-$i -- set interface patch3-$i type=patch options:peer=patch$j-3 ofport=$j
fi
done