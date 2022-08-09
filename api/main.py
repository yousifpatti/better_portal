
# A very simple Flask Hello World app for you to get started with...

from flask import Flask, redirect, url_for, jsonify, request, session
import requests
import re
import pickle as pk
from datetime import timedelta
import os
from google.cloud import storage
from parser import get_json
from datetime import datetime
from flask_cors import CORS, cross_origin

app = Flask(__name__)
app.secret_key = "super secret key"
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

bucket = "bunny-session"

storage_client = storage.Client()
bucket = storage_client.get_bucket(bucket)


@app.before_request
def make_session_permanent():
    session.permanent = True
    app.permanent_session_lifetime = timedelta(minutes=5)


def open_session():
    s = requests.Session()
    s.headers.update({"Access-Control-Allow-Methods":
    "OPTIONS, GET, POST, PUT, PATCH, DELETE", 'Access-Control-Allow-Origin': '*'})
    res = s.get('https://teamportal.bunnings.com.au/')
    # no update headers here
    return s


def login(mail, password):
    s = open_session()
    payload = {
        "username": mail,
        "password": password,
        "vhost": 'standard'
    }
    res = s.post('https://teamportal.bunnings.com.au/my.policy', data=payload)
    # no update headers here
    return s


def MFA(s, code):
    payload = {
        "_F5_challenge": code,
        "vhost": 'standard'
    }
    res = s.post('https://teamportal.bunnings.com.au/my.policy', data=payload)
    # no update headers here
    #print(res.content)
    return s


def intermediate(s):
    payload = {
        "choice": '1',
    }
    res = s.post('https://teamportal.bunnings.com.au/my.policy', data=payload)
    # no update headers here
    #print(res.content)

    res = s.get('https://teamportal.bunnings.com.au/vdesk/webtop.eui?webtop=/Common/teamportal_wt&webtop_type=webtop_full')
    # no update headers here
    #print(res.content)
    return s


def R3(s):
    res = s.post('https://teamportal.bunnings.com.au/f5-w-68747470733a2f2f72332e6262732e62756e6e696e67732e636f6d2e6175$$/login.jsp?config=false&locale=EN')
    # no update headers here
    #print(res.headers)
    re_object = re.search('<input type="hidden" value=(.*) name="url_login_token">', str(res.content))
    token = re_object.group(1)
    return s, token, res.headers.get('wbat')

def login_R3(s, mail, password, token, wbat):
    payload = {
        "wbat": wbat,
        "pageAction": 'login',
        "url_login_token": token,
        "login": mail,
        "password": password,
        "wbXpos": '0',
        "wbYpos": '0'

    }
    res = s.post('https://teamportal.bunnings.com.au/f5-w-68747470733a2f2f72332e6262732e62756e6e696e67732e636f6d2e6175$$/login.jsp', data=payload)
    # no update headers here
    #print(res.content)
    return s


def get_calender(s, wbat, month):
    payload = {
        "wbat": wbat,
        "pageAction": '',
        "NEW_MONTH_YEAR": month,
        "wbXpos": '0',
        "wbYpos": '0'

    }
    res = s.post('https://teamportal.bunnings.com.au/f5-w-68747470733a2f2f72332e6262732e62756e6e696e67732e636f6d2e6175$$/bunnings/etm/externalAccess/teamPortalMonthlyRoster.jsp', data=payload)
    return res


def serialize_session(session):
    return pk.dumps(session)


def deserialize_session(data):
    return pk.loads(data)


@app.route('/login', methods=['POST'])
def login_page():
    # if not request.json or (not 'user' in request.json and not 'password' in request.json):
    #     return 'hello'

    data = request.get_json()

    sesh = login(data['user'], data['pass'])

    #session[data['user']] = serialize_session(sesh)

     # Create a new blob and upload the file's content.
    bolb = bucket.blob(data['user'])
    with bolb.open(mode='wb') as f:
        f.write(serialize_session(sesh))
    # with open(data['user'], "wb") as output_file:
    #     pk.dump(sesh, output_file)

    response = jsonify({"Status" : "OK"})
    response.headers.add("Access-Control-Allow-Methods",
    "OPTIONS, GET, POST, PUT, PATCH, DELETE")
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')

    return response


@app.route('/mfa', methods=['POST'])
def doMfa():
    # if not request.json or (not 'user' in request.json and not 'password' in request.json):
    #     return 'hello'

    data = request.get_json()
    username = data['user']
    password = data['pass']
    code = data['code']

    #sesh = deserialize_session(session.pop(username))

    bolb = bucket.blob(username)
    with bolb.open(mode='rb') as f:
        sesh = deserialize_session(f.read())

    # with open(username, "rb") as input_file:
    #     sesh = pk.load(input_file)

    mfa_sesh = MFA(sesh, code)

    intermediate_session = intermediate(mfa_sesh)

    r3_session, tkn, wbat = R3(intermediate_session)
    login_session = login_R3(r3_session, username, password, tkn, wbat)
    roster = {}

    current_month = datetime.now().month
    next_month = (current_month + 1) % 12

    current_year = datetime.now().year
    if (next_month < current_month):
        next_year = current_year + 1
    else:
        next_year = current_year


    string_current_month = str(current_month).zfill(2) + '/' + str(current_year)
    string_next_month = str(next_month).zfill(2) + '/' + str(next_year)

    #roster["year"] = str(current_year)

    roster = {}

    res = get_calender(login_session, wbat, string_current_month)
    mo, moList = get_json(res.content).popitem()
    roster[mo] = moList
    #roster[string_current_month.lstrip('0')] = get_json(res.content)
    #roster["August"] = get_json(res.content)


    res = get_calender(login_session, wbat, string_next_month)
    mo, moList = get_json(res.content).popitem()
    roster[mo] = moList


    response = jsonify(roster)
    response.headers.add("Access-Control-Allow-Methods",
    "OPTIONS, GET, POST, PUT, PATCH, DELETE")
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')

    return response



@app.route('/')
def hello_world():
    response = jsonify({'1':'1'})
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response


if __name__ == "__main__":
    # from waitress import serve
    # serve(app, host="127.0.0.1", port=5000)
    app.run(debug=False, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
