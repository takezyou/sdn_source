# -*- coding: utf-8 -*-
import peewee

# データベースを指定
db = peewee.SqliteDatabase("data.db")

# ユーザーモデルを定義
class Flow(peewee.Model):
    in_port = peewee.IntegerField()
    mac_address = peewee.TextField()
    out_port = peewee.IntegerField()
    datapath = peewee.TextField()

    class Meta:
        database = db

# ユーザーテーブル作成
Flow.create_table()

# tsvファイルを一行ずつ読み込んでタブで分割し，それぞれをデータベースに登録
for line in open("flow.csv", "r"):
    (in_port, mac_address, out_port, datapath) = tuple(line[:-1].split("\t"))
    if datapath.isdigit(): # 一行目のコメント対応．
        Flow.create(in_port = int(in_port),
                    mac_address = mac_address,
                    out_port = int(out_port),
                    datapath = datapath)
