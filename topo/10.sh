if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "host1"` ]] ; then
  ovs-vsctl del-port s1 host1
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "host2"` ]] ; then
  ovs-vsctl del-port s2 host2
fi
ovs-vsctl add-port s1 host1 -- set interface host1 ofport=1
ovs-vsctl add-port s2 host2 -- set interface host2 ofport=1
#
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "host3"` ]] ; then
  ovs-vsctl del-port s3 host3
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "host4"` ]] ; then
  ovs-vsctl del-port s4 host4
fi
ovs-vsctl add-port s3 host3 -- set interface host3 ofport=1
ovs-vsctl add-port s4 host4 -- set interface host4 ofport=1

if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-1"` ]] ; then
  ovs-vsctl del-port s1 patch1-1
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-2"` ]] ; then
  ovs-vsctl del-port s1 patch1-2
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-3"` ]] ; then
  ovs-vsctl del-port s1 patch1-3
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-4"` ]] ; then
  ovs-vsctl del-port s1 patch1-4
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-5"` ]] ; then
  ovs-vsctl del-port s1 patch1-5
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-6"` ]] ; then
  ovs-vsctl del-port s1 patch1-6
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-7"` ]] ; then
  ovs-vsctl del-port s1 patch1-7
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-8"` ]] ; then
  ovs-vsctl del-port s1 patch1-8
fi
if [[ `ovs-ofctl show s1 --protocol=OpenFlow13 | grep "patch1-9"` ]] ; then
  ovs-vsctl del-port s1 patch1-9
fi
ovs-vsctl add-port s1 patch1-1 -- set interface patch1-1 type=patch options:peer=patch2-1 ofport=2
ovs-vsctl add-port s1 patch1-2 -- set interface patch1-2 type=patch options:peer=patch3-1 ofport=3
ovs-vsctl add-port s1 patch1-3 -- set interface patch1-3 type=patch options:peer=patch4-1 ofport=4
ovs-vsctl add-port s1 patch1-4 -- set interface patch1-4 type=patch options:peer=patch5-1 ofport=5
ovs-vsctl add-port s1 patch1-5 -- set interface patch1-5 type=patch options:peer=patch6-1 ofport=6
ovs-vsctl add-port s1 patch1-6 -- set interface patch1-6 type=patch options:peer=patch7-1 ofport=7
ovs-vsctl add-port s1 patch1-7 -- set interface patch1-7 type=patch options:peer=patch8-1 ofport=8
ovs-vsctl add-port s1 patch1-8 -- set interface patch1-8 type=patch options:peer=patch9-1 ofport=9
ovs-vsctl add-port s1 patch1-9 -- set interface patch1-9 type=patch options:peer=patch10-1 ofport=10

if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-1"` ]] ; then
  ovs-vsctl del-port s2 patch2-1
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-2"` ]] ; then
  ovs-vsctl del-port s2 patch2-2
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-3"` ]] ; then
  ovs-vsctl del-port s2 patch2-3
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-4"` ]] ; then
  ovs-vsctl del-port s2 patch2-4
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-5"` ]] ; then
  ovs-vsctl del-port s2 patch2-5
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-6"` ]] ; then
  ovs-vsctl del-port s2 patch2-6
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-7"` ]] ; then
  ovs-vsctl del-port s2 patch2-7
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-8"` ]] ; then
  ovs-vsctl del-port s2 patch2-8
fi
if [[ `ovs-ofctl show s2 --protocol=OpenFlow13 | grep "patch2-9"` ]] ; then
  ovs-vsctl del-port s2 patch2-9
fi

ovs-vsctl add-port s2 patch2-1 -- set interface patch2-1 type=patch options:peer=patch1-1 ofport=2
ovs-vsctl add-port s2 patch2-2 -- set interface patch2-2 type=patch options:peer=patch3-2 ofport=3
ovs-vsctl add-port s2 patch2-3 -- set interface patch2-3 type=patch options:peer=patch4-2 ofport=4
ovs-vsctl add-port s2 patch2-4 -- set interface patch2-4 type=patch options:peer=patch5-2 ofport=5
ovs-vsctl add-port s2 patch2-5 -- set interface patch2-5 type=patch options:peer=patch6-2 ofport=6
ovs-vsctl add-port s2 patch2-6 -- set interface patch2-6 type=patch options:peer=patch7-2 ofport=7
ovs-vsctl add-port s2 patch2-7 -- set interface patch2-7 type=patch options:peer=patch8-2 ofport=8
ovs-vsctl add-port s2 patch2-8 -- set interface patch2-8 type=patch options:peer=patch9-2 ofport=9
ovs-vsctl add-port s2 patch2-9 -- set interface patch2-9 type=patch options:peer=patch10-2 ofport=10


if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-1"` ]] ; then
  ovs-vsctl del-port s3 patch3-1
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-2"` ]] ; then
  ovs-vsctl del-port s3 patch3-2
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-3"` ]] ; then
  ovs-vsctl del-port s3 patch3-3
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-4"` ]] ; then
  ovs-vsctl del-port s3 patch3-4
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-5"` ]] ; then
  ovs-vsctl del-port s3 patch3-5
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-6"` ]] ; then
  ovs-vsctl del-port s3 patch3-6
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-7"` ]] ; then
  ovs-vsctl del-port s3 patch3-7
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-8"` ]] ; then
  ovs-vsctl del-port s3 patch3-8
fi
if [[ `ovs-ofctl show s3 --protocol=OpenFlow13 | grep "patch3-9"` ]] ; then
  ovs-vsctl del-port s3 patch3-9
fi
ovs-vsctl add-port s3 patch3-1 -- set interface patch3-1 type=patch options:peer=patch1-2 ofport=2
ovs-vsctl add-port s3 patch3-2 -- set interface patch3-2 type=patch options:peer=patch2-2 ofport=3
ovs-vsctl add-port s3 patch3-3 -- set interface patch3-3 type=patch options:peer=patch4-3 ofport=4
ovs-vsctl add-port s3 patch3-4 -- set interface patch3-4 type=patch options:peer=patch5-3 ofport=5
ovs-vsctl add-port s3 patch3-5 -- set interface patch3-5 type=patch options:peer=patch6-3 ofport=6
ovs-vsctl add-port s3 patch3-6 -- set interface patch3-6 type=patch options:peer=patch7-3 ofport=7
ovs-vsctl add-port s3 patch3-7 -- set interface patch3-7 type=patch options:peer=patch8-3 ofport=8
ovs-vsctl add-port s3 patch3-8 -- set interface patch3-8 type=patch options:peer=patch9-3 ofport=9
ovs-vsctl add-port s3 patch3-9 -- set interface patch3-9 type=patch options:peer=patch10-3 ofport=10


if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-1"` ]] ; then
  ovs-vsctl del-port s4 patch4-1
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-2"` ]] ; then
  ovs-vsctl del-port s4 patch4-2
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-3"` ]] ; then
  ovs-vsctl del-port s4 patch4-3
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-4"` ]] ; then
  ovs-vsctl del-port s4 patch4-4
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-5"` ]] ; then
  ovs-vsctl del-port s4 patch4-5
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-6"` ]] ; then
  ovs-vsctl del-port s4 patch4-6
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-7"` ]] ; then
  ovs-vsctl del-port s4 patch4-7
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-8"` ]] ; then
  ovs-vsctl del-port s4 patch4-8
fi
if [[ `ovs-ofctl show s4 --protocol=OpenFlow13 | grep "patch4-9"` ]] ; then
  ovs-vsctl del-port s4 patch4-9
fi
ovs-vsctl add-port s4 patch4-1 -- set interface patch4-1 type=patch options:peer=patch1-3 ofport=2
ovs-vsctl add-port s4 patch4-2 -- set interface patch4-2 type=patch options:peer=patch2-3 ofport=3
ovs-vsctl add-port s4 patch4-3 -- set interface patch4-3 type=patch options:peer=patch3-3 ofport=4
ovs-vsctl add-port s4 patch4-4 -- set interface patch4-4 type=patch options:peer=patch5-4 ofport=5
ovs-vsctl add-port s4 patch4-5 -- set interface patch4-5 type=patch options:peer=patch6-4 ofport=6
ovs-vsctl add-port s4 patch4-6 -- set interface patch4-6 type=patch options:peer=patch7-4 ofport=7
ovs-vsctl add-port s4 patch4-7 -- set interface patch4-7 type=patch options:peer=patch8-4 ofport=8
ovs-vsctl add-port s4 patch4-8 -- set interface patch4-8 type=patch options:peer=patch9-4 ofport=9
ovs-vsctl add-port s4 patch4-9 -- set interface patch4-9 type=patch options:peer=patch10-4 ofport=10


if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-1"` ]] ; then
  ovs-vsctl del-port s5 patch5-1
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-2"` ]] ; then
  ovs-vsctl del-port s5 patch5-2
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-3"` ]] ; then
  ovs-vsctl del-port s5 patch5-3
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-4"` ]] ; then
  ovs-vsctl del-port s5 patch5-4
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-5"` ]] ; then
  ovs-vsctl del-port s5 patch5-5
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-6"` ]] ; then
  ovs-vsctl del-port s5 patch5-6
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-7"` ]] ; then
  ovs-vsctl del-port s5 patch5-7
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-8"` ]] ; then
  ovs-vsctl del-port s5 patch5-8
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-9"` ]] ; then
  ovs-vsctl del-port s5 patch5-9
fi
ovs-vsctl add-port s5 patch5-1 -- set interface patch5-1 type=patch options:peer=patch1-4 ofport=2
ovs-vsctl add-port s5 patch5-2 -- set interface patch5-2 type=patch options:peer=patch2-4 ofport=3
ovs-vsctl add-port s5 patch5-3 -- set interface patch5-3 type=patch options:peer=patch3-4 ofport=4
ovs-vsctl add-port s5 patch5-4 -- set interface patch5-4 type=patch options:peer=patch4-4 ofport=5
ovs-vsctl add-port s5 patch5-5 -- set interface patch5-5 type=patch options:peer=patch6-5 ofport=6
ovs-vsctl add-port s5 patch5-6 -- set interface patch5-6 type=patch options:peer=patch7-5 ofport=7
ovs-vsctl add-port s5 patch5-7 -- set interface patch5-7 type=patch options:peer=patch8-5 ofport=8
ovs-vsctl add-port s5 patch5-8 -- set interface patch5-8 type=patch options:peer=patch9-5 ofport=9
ovs-vsctl add-port s5 patch5-9 -- set interface patch5-9 type=patch options:peer=patch10-5 ofport=10

if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-1"` ]] ; then
  ovs-vsctl del-port s6 patch6-1
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-2"` ]] ; then
  ovs-vsctl del-port s6 patch6-2
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-3"` ]] ; then
  ovs-vsctl del-port s6 patch6-3
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-4"` ]] ; then
  ovs-vsctl del-port s6 patch6-4
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-5"` ]] ; then
  ovs-vsctl del-port s6 patch6-5
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-6"` ]] ; then
  ovs-vsctl del-port s6 patch6-6
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-7"` ]] ; then
  ovs-vsctl del-port s6 patch6-7
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-8"` ]] ; then
  ovs-vsctl del-port s6 patch6-8
fi
if [[ `ovs-ofctl show s6 --protocol=OpenFlow13 | grep "patch6-9"` ]] ; then
  ovs-vsctl del-port s6 patch6-9
fi
ovs-vsctl add-port s6 patch6-1 -- set interface patch6-1 type=patch options:peer=patch1-5 ofport=2
ovs-vsctl add-port s6 patch6-2 -- set interface patch6-2 type=patch options:peer=patch2-5 ofport=3
ovs-vsctl add-port s6 patch6-3 -- set interface patch6-3 type=patch options:peer=patch3-5 ofport=4
ovs-vsctl add-port s6 patch6-4 -- set interface patch6-4 type=patch options:peer=patch4-5 ofport=5
ovs-vsctl add-port s6 patch6-5 -- set interface patch6-5 type=patch options:peer=patch5-5 ofport=6
ovs-vsctl add-port s6 patch6-6 -- set interface patch6-6 type=patch options:peer=patch7-6 ofport=7
ovs-vsctl add-port s6 patch6-7 -- set interface patch6-7 type=patch options:peer=patch8-6 ofport=8
ovs-vsctl add-port s6 patch6-8 -- set interface patch6-8 type=patch options:peer=patch9-6 ofport=9
ovs-vsctl add-port s6 patch6-9 -- set interface patch6-9 type=patch options:peer=patch10-6 ofport=10

if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-1"` ]] ; then
  ovs-vsctl del-port s7 patch7-1
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-2"` ]] ; then
  ovs-vsctl del-port s7 patch7-2
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-3"` ]] ; then
  ovs-vsctl del-port s7 patch7-3
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-4"` ]] ; then
  ovs-vsctl del-port s7 patch7-4
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-5"` ]] ; then
  ovs-vsctl del-port s7 patch7-5
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-6"` ]] ; then
  ovs-vsctl del-port s7 patch7-6
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-7"` ]] ; then
  ovs-vsctl del-port s7 patch7-7
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-8"` ]] ; then
  ovs-vsctl del-port s7 patch7-8
fi
if [[ `ovs-ofctl show s7 --protocol=OpenFlow13 | grep "patch7-9"` ]] ; then
  ovs-vsctl del-port s7 patch7-9
fi
ovs-vsctl add-port s7 patch7-1 -- set interface patch7-1 type=patch options:peer=patch1-6 ofport=2
ovs-vsctl add-port s7 patch7-2 -- set interface patch7-2 type=patch options:peer=patch2-6 ofport=3
ovs-vsctl add-port s7 patch7-3 -- set interface patch7-3 type=patch options:peer=patch3-6 ofport=4
ovs-vsctl add-port s7 patch7-4 -- set interface patch7-4 type=patch options:peer=patch4-6 ofport=5
ovs-vsctl add-port s7 patch7-5 -- set interface patch7-5 type=patch options:peer=patch5-6 ofport=6
ovs-vsctl add-port s7 patch7-6 -- set interface patch7-6 type=patch options:peer=patch6-6 ofport=7
ovs-vsctl add-port s7 patch7-7 -- set interface patch7-7 type=patch options:peer=patch8-7 ofport=8
ovs-vsctl add-port s7 patch7-8 -- set interface patch7-8 type=patch options:peer=patch9-7 ofport=9
ovs-vsctl add-port s7 patch7-9 -- set interface patch7-9 type=patch options:peer=patch10-7 ofport=10

if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-1"` ]] ; then
  ovs-vsctl del-port s5 patch5-1
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-2"` ]] ; then
  ovs-vsctl del-port s5 patch5-2
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-3"` ]] ; then
  ovs-vsctl del-port s5 patch5-3
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-4"` ]] ; then
  ovs-vsctl del-port s5 patch5-4
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-5"` ]] ; then
  ovs-vsctl del-port s5 patch5-5
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-6"` ]] ; then
  ovs-vsctl del-port s5 patch5-6
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-7"` ]] ; then
  ovs-vsctl del-port s5 patch5-7
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-8"` ]] ; then
  ovs-vsctl del-port s5 patch5-8
fi
if [[ `ovs-ofctl show s5 --protocol=OpenFlow13 | grep "patch5-9"` ]] ; then
  ovs-vsctl del-port s5 patch5-9
fi
ovs-vsctl add-port s5 patch5-1 -- set interface patch5-1 type=patch options:peer=patch1-4 ofport=2
ovs-vsctl add-port s5 patch5-2 -- set interface patch5-2 type=patch options:peer=patch2-4 ofport=3
ovs-vsctl add-port s5 patch5-3 -- set interface patch5-3 type=patch options:peer=patch3-4 ofport=4
ovs-vsctl add-port s5 patch5-4 -- set interface patch5-4 type=patch options:peer=patch4-4 ofport=5
ovs-vsctl add-port s5 patch5-5 -- set interface patch5-5 type=patch options:peer=patch6-5 ofport=6
ovs-vsctl add-port s5 patch5-6 -- set interface patch5-6 type=patch options:peer=patch7-5 ofport=7
ovs-vsctl add-port s5 patch5-7 -- set interface patch5-7 type=patch options:peer=patch8-5 ofport=8
ovs-vsctl add-port s5 patch5-8 -- set interface patch5-8 type=patch options:peer=patch9-5 ofport=9
ovs-vsctl add-port s5 patch5-9 -- set interface patch5-9 type=patch options:peer=patch10-5 ofport=10

if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-1"` ]] ; then
  ovs-vsctl del-port s8 patch8-1
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-2"` ]] ; then
  ovs-vsctl del-port s8 patch8-2
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-3"` ]] ; then
  ovs-vsctl del-port s8 patch8-3
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-4"` ]] ; then
  ovs-vsctl del-port s8 patch8-4
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-5"` ]] ; then
  ovs-vsctl del-port s8 patch8-5
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-6"` ]] ; then
  ovs-vsctl del-port s8 patch8-6
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-7"` ]] ; then
  ovs-vsctl del-port s8 patch8-7
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-8"` ]] ; then
  ovs-vsctl del-port s8 patch8-8
fi
if [[ `ovs-ofctl show s8 --protocol=OpenFlow13 | grep "patch8-9"` ]] ; then
  ovs-vsctl del-port s8 patch8-9
fi
ovs-vsctl add-port s8 patch8-1 -- set interface patch8-1 type=patch options:peer=patch1-7 ofport=2
ovs-vsctl add-port s8 patch8-2 -- set interface patch8-2 type=patch options:peer=patch2-7 ofport=3
ovs-vsctl add-port s8 patch8-3 -- set interface patch8-3 type=patch options:peer=patch3-7 ofport=4
ovs-vsctl add-port s8 patch8-4 -- set interface patch8-4 type=patch options:peer=patch4-7 ofport=5
ovs-vsctl add-port s8 patch8-5 -- set interface patch8-5 type=patch options:peer=patch5-7 ofport=6
ovs-vsctl add-port s8 patch8-6 -- set interface patch8-6 type=patch options:peer=patch6-7 ofport=7
ovs-vsctl add-port s8 patch8-7 -- set interface patch8-7 type=patch options:peer=patch7-7 ofport=8
ovs-vsctl add-port s8 patch8-8 -- set interface patch8-8 type=patch options:peer=patch9-8 ofport=9
ovs-vsctl add-port s8 patch8-9 -- set interface patch8-9 type=patch options:peer=patch10-8 ofport=10

if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-1"` ]] ; then
  ovs-vsctl del-port s9 patch9-1
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-2"` ]] ; then
  ovs-vsctl del-port s9 patch9-2
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-3"` ]] ; then
  ovs-vsctl del-port s9 patch9-3
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-4"` ]] ; then
  ovs-vsctl del-port s9 patch9-4
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-5"` ]] ; then
  ovs-vsctl del-port s9 patch9-5
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-6"` ]] ; then
  ovs-vsctl del-port s9 patch9-6
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-7"` ]] ; then
  ovs-vsctl del-port s9 patch9-7
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-8"` ]] ; then
  ovs-vsctl del-port s9 patch9-8
fi
if [[ `ovs-ofctl show s9 --protocol=OpenFlow13 | grep "patch9-9"` ]] ; then
  ovs-vsctl del-port s9 patch9-9
fi
ovs-vsctl add-port s9 patch9-1 -- set interface patch9-1 type=patch options:peer=patch1-8 ofport=2
ovs-vsctl add-port s9 patch9-2 -- set interface patch9-2 type=patch options:peer=patch2-8 ofport=3
ovs-vsctl add-port s9 patch9-3 -- set interface patch9-3 type=patch options:peer=patch3-8 ofport=4
ovs-vsctl add-port s9 patch9-4 -- set interface patch9-4 type=patch options:peer=patch4-8 ofport=5
ovs-vsctl add-port s9 patch9-5 -- set interface patch9-5 type=patch options:peer=patch5-8 ofport=6
ovs-vsctl add-port s9 patch9-6 -- set interface patch9-6 type=patch options:peer=patch6-8 ofport=7
ovs-vsctl add-port s9 patch9-7 -- set interface patch9-7 type=patch options:peer=patch7-8 ofport=8
ovs-vsctl add-port s9 patch9-8 -- set interface patch9-8 type=patch options:peer=patch8-8 ofport=9
ovs-vsctl add-port s9 patch9-9 -- set interface patch9-9 type=patch options:peer=patch10-9 ofport=10

if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-1"` ]] ; then
  ovs-vsctl del-port s10 patch10-1
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-2"` ]] ; then
  ovs-vsctl del-port s10 patch10-2
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-3"` ]] ; then
  ovs-vsctl del-port s10 patch10-3
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-4"` ]] ; then
  ovs-vsctl del-port s10 patch10-4
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-5"` ]] ; then
  ovs-vsctl del-port s10 patch10-5
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-6"` ]] ; then
  ovs-vsctl del-port s10 patch10-6
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-7"` ]] ; then
  ovs-vsctl del-port s10 patch10-7
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-8"` ]] ; then
  ovs-vsctl del-port s10 patch10-8
fi
if [[ `ovs-ofctl show s10 --protocol=OpenFlow13 | grep "patch10-9"` ]] ; then
  ovs-vsctl del-port s10 patch10-9
fi
ovs-vsctl add-port s10 patch10-1 -- set interface patch10-1 type=patch options:peer=patch1-9 ofport=2
ovs-vsctl add-port s10 patch10-2 -- set interface patch10-2 type=patch options:peer=patch2-9 ofport=3
ovs-vsctl add-port s10 patch10-3 -- set interface patch10-3 type=patch options:peer=patch3-9 ofport=4
ovs-vsctl add-port s10 patch10-4 -- set interface patch10-4 type=patch options:peer=patch4-9 ofport=5
ovs-vsctl add-port s10 patch10-5 -- set interface patch10-5 type=patch options:peer=patch5-9 ofport=6
ovs-vsctl add-port s10 patch10-6 -- set interface patch10-6 type=patch options:peer=patch6-9 ofport=7
ovs-vsctl add-port s10 patch10-7 -- set interface patch10-7 type=patch options:peer=patch7-9 ofport=8
ovs-vsctl add-port s10 patch10-8 -- set interface patch10-8 type=patch options:peer=patch8-9 ofport=9
ovs-vsctl add-port s10 patch10-9 -- set interface patch10-9 type=patch options:peer=patch9-9 ofport=10
