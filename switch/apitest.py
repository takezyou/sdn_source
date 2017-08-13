from flask import Flask, jsonify, abort, make_response
import peewee

db = peewee.SqliteDatabase("/root/data.db")

class Flow(peewee.Model):
    in_port = peewee.IntegerField()
    mac_address = peewee.TextField()
    out_port = peewee.IntegerField()
    datapath = peewee.TextField()
    
    class Meta:
        database = db

api = Flask(__name__)

@api.route('/add/<string:in_port>', methods=['GET'])
def get_flow(in_port):
    try:
        flow = Flow.get(Flow.in_port == in_port)
    except Flow.DoesNotExist:
        abort(404)

    result = {
        "result":True,
            "data":{
            "in_port":flow.in_port,
            "mac_address":flow.mac_address,
            "out_port":flow.out_port,
            "datapath":flow.datapath
            }
        }

    return make_response(jsonify(result))

@api.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    api.run(host='10.50.0.100', port=8080)