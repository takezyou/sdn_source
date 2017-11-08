#!/usr/bin/python2.7.2
# -*- coding: utf-8 -*-

import sys, math
import MySQLdb
import csv

# constant
DB_USER = "root"
DB_PSWD = ""


# createtables
def execute_sql():

    try:
        conn = MySQLdb.connect( db="ryu_db",user=DB_USER, passwd=DB_PSWD, charset="utf8")
        cursor = conn.cursor()

        cursor.execute("insert into vlan(vlan, start, end, path) values(10, '1-1', '2-2', '1-1,1-3,3-1,3-2,2-3,2-2')")

        conn.commit()


    except MySQLdb.Error, e:
        print "SQL ERROR %d: %s" % (e.args[0], e.args[1])
        sys.exit(1)

    finally:
        if cursor: cursor.close
        if conn: conn.close


# メイン処理部
if __name__ == "__main__":

    execute_sql()