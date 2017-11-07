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

        cursor.execute("DROP TABLE IF EXISTS topology")
        cursor.execute("CREATE TABLE IF NOT EXISTS topology(id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, dport1 VARCHAR(128), dport2 VARCHAR(128), delay FLOAT, judge CHAR(32))")
        cursor.execute("DROP TABLE IF EXISTS vlan")
        cursor.execute("CREATE TABLE IF NOT EXISTS vlan(vlan INT NOT NULL PRIMARY KEY, start VARCHAR(128), end VARCHAR(128), path VARCHAR(32))")

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