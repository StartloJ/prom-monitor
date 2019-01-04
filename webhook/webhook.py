import os
import logging
from datetime import datetime, timedelta
from flask import Flask, request, abort, jsonify , render_template
import requests

def temp_token():
    import binascii
    temp_token = binascii.hexlify(os.urandom(24))
    return temp_token.decode('utf-8')

logFormatter = logging.Formatter("%(asctime)s [%(threadName)-12.12s] [%(levelname)-5.5s]  %(message)s")
rootLogger = logging.getLogger()
rootLogger.setLevel(logging.DEBUG)

consoleHandler = logging.StreamHandler()
consoleHandler.setFormatter(logFormatter)
rootLogger.addHandler(consoleHandler)

WEBHOOK_VERIFY_TOKEN = os.getenv('WEBHOOK_VERIFY_TOKEN')
CLIENT_AUTH_TIMEOUT = 24 # in Hours

app = Flask(__name__)

def re_ftime(dtime):
    raw_time = dtime.split('T')
    date = raw_time[0]
    time = raw_time[1].split('.')[0]
    return date + " " + time

def alert_line(data,token):
    severity = ''
    summary = ''
    desc = ''
    stime = ''
    if data['status'] == "firing":
        for alert in data['alerts']:
            severity = alert['labels']['severity']
            summary = alert['annotations']['summary']
            desc = alert['annotations']['description']
            stime = re_ftime(alert['startsAt'])
            url = "https://notify-api.line.me/api/notify"
            message ="Problem!!\nSeverity: " + severity + "\nTime: " + stime + "\nSummary: " + summary + "\nDescription: " + desc
            header = {'Authorization':token}
            payload = {'message': str(message)}
            r = requests.post(url , headers=header,data=payload)
            print(r.content)
    else: pass

@app.route('/webhook', methods=['GET', 'POST'])
def webhook():
    rootLogger.info(request.remote_addr + "on method : " + request.method)
    if request.method == 'GET':
        verify_token = request.args.get('verify_token')
        if verify_token == WEBHOOK_VERIFY_TOKEN:
            return jsonify({'status':'success'}), 200
        else:
            return jsonify({'status':'bad token'}), 401

    elif request.method == 'POST':
        client = request.remote_addr
        line_token = request.headers['AUTHORIZATION']
        alert_line(request.json,line_token)
        return jsonify({'status':'success'}), 200
    else:
        abort(400)

@app.route('/get_token_webhook', methods=['GET'])
def get_token_webhook():
    return render_template('token.html',get_token=WEBHOOK_VERIFY_TOKEN)

if __name__ == '__main__':
    if WEBHOOK_VERIFY_TOKEN is None:
        print('WEBHOOK_VERIFY_TOKEN has not been set in the environment.\nGenerating random token...')
        token = temp_token()
        print('Token: %s' % token)
        WEBHOOK_VERIFY_TOKEN = token
    app.run(host='0.0.0.0') #default allow on port 5000.