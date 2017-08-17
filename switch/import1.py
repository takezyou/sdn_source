# -*- coding: utf-8 -*-
import peewee

# データベースを指定
db = peewee.SqliteDatabase("data1.db")

# ユーザーモデルを定義
class Flow1(peewee.Model):
    in_port1 = peewee.IntegerField()
    mac_address1 = peewee.TextField()
    out_port1 = peewee.IntegerField()
    in_port2 = peewee.IntegerField()
    mac_address2 = peewee.TextField()
    out_port2 = peewee.IntegerField()
    datapath = peewee.TextField()

    class Meta:
        database = db

# ユーザーテーブル作成
Flow1.create_table()

# tsvファイルを一行ずつ読み込んでタブで分割し，それぞれをデータベースに登録
for line in open("flow2.csv", "r"):
    (in_port1, mac_address1, out_port1, in_port2, mac_address2, out_port2, datapath) = tuple(line[:-1].split("\t"))
    if datapath.isdigit(): # 一行目のコメント対応．
        Flow1.create(in_port1 = int(in_port1),
                    mac_address1 = mac_address1,
                    out_port1 = int(out_port1),
                    in_port2 = int(in_port2),
                    mac_address2 = mac_address2,
                    out_port2 = int(out_port2),
                    datapath = datapath)