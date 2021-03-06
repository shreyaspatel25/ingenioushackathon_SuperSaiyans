# Python dependancies
import os
import sys
import socket

# Import Dependancies 
reload(sys)
sys.path.append('./dependancies/')
sys.setdefaultencoding('utf-8')

from flask import Flask, render_template, request, redirect, session
from weather import Weather
from time import gmtime, strftime

from connectDB import *
from authentication import *
from manipulate_data import *

# App
app = Flask(__name__)

app.config['SECRET_KEY'] = 'agro'

HOSTNAME = socket.gethostname()
HOSTADDRESS = socket.gethostbyname(HOSTNAME)
PORT = 8080
DOMAIN = "http://" + HOSTADDRESS + ":" + str(PORT) + "/"

#### App
@app.route('/')
def index():
    return render_template('index.html', domain=DOMAIN)

#### SignUP Page
@app.route('/signup',methods = ['GET','POST'])
def signup():
    if request.method == 'GET':
        if 'username' in session:
            return redirect(DOMAIN + session['username'], code=302)
        else:
            pin_area = extract_area()
            states = extract_state()
            return render_template('signup.html', \
                                    domain=DOMAIN , \
                                    pin_area_tuple=pin_area, \
                                    state=states)

    elif request.method == 'POST':
        user_data = {}
        user_data['phone_no'] = request.form['phone_no']
        user_data['password'] = request.form['password']
        user_data['first_name'] = request.form['first_name']
        user_data['last_name'] = request.form['last_name']
        user_data['email_id'] = request.form['email_id']
        user_data['address_line_1'] = request.form['address_line_1']
        user_data['address_line_2'] = request.form['address_line_2']
        user_data['gender'] = request.form['gender']
        user_data['pin'] = request.form['pin']
        user_data['aadhar_no'] = request.form['aadhar_no']
        user_data['dob'] = '29-05-1997'
        user_data['online_status'] = 'N'

        isSuccess = registration(user_data)

        if isSuccess:
            return render_template('login.html', \
                                    domain=DOMAIN, \
                                    info="Please login with your details.")
        else:
            return render_template('signup.html', \
                                    domain=DOMAIN, \
                                    info="Please try again.")
    else:
        pin_area = extract_area()
        states = extract_state()
        return render_template('signup.html', \
                                domain=DOMAIN , \
                                pin_area_tuple=pin_area, \
                                state=states, \
                                info="")

@app.route('/login', methods = ['GET','POST'])
def login():
    if request.method == 'GET':
        if 'username' in session:
            return redirect(DOMAIN + session['username'], code=302)
        return render_template('login.html', domain=DOMAIN)
    elif request.method == 'POST':
        phone_no = request.form['phone_no']
        password = request.form['password']

        session['username']=phone_no

        if auth_login(phone_no, password):
            return redirect(DOMAIN + session['username'], code=302)
        else:
            return render_template('login.html', \
                                domain=DOMAIN, \
                                info="Please enter valid username or password.")

@app.route('/<username>',methods = ['GET','POST'])
def dashboard(username):
    if 'username' in session:
        if session['username']==username:
            if request.method=='POST':
                if "farmer_res" in request.form:
                    insertOccupation(username, '01')              
                elif "logistics_res" in request.form:
                    insertOccupation(username, '03') 
                elif "tools_res" in request.form:
                    insertOccupation(username, '04') 
                elif "trader_res" in request.form:
                    insertOccupation(username, '02') 
                else:
                    pass

            occupations = extract_occupations(str(username))
            rem_occupations = extract_remain_occupations(str(username))
            return render_template('dashboard.html', \
                                occupation=occupations, \
                                remain_occ=rem_occupations, \
                                domain=DOMAIN, \
                                username=username)
        else:
            return redirect(DOMAIN, code=302)    
    else:
        return redirect(DOMAIN, code=302)  


@app.route('/<username>/logout',methods = ['GET'])
def logout(username):
    if session['username'] == username:
        session.pop('username',None)
        return redirect(DOMAIN, code=302)
    elif session['username'] != username:
        return "Page Not Found!"

@app.route('/<username>/farmer',methods = ['GET'])
def farmer(username):
    if session['username'] == username:
        weather_data = getWeatherData()
        return render_template('farmer.html', \
                            domain=DOMAIN, \
                            username=username, \
                            weatherdata=weather_data)
    elif session['username'] != username:
        return "Page Not Found!"

@app.route('/<username>/trader',methods = ['GET','POST'])
def trader(username):
    if session['username'] == username:
        sold_Data = extract_soldData()
        info=""

        if request.method=='POST':
            crop_request_entry = request.form['crop_request_entry']
            trader_no = username
            bid_amount = request.form['bid_amount']

            if insertBid(crop_request_entry, trader_no, bid_amount):
                info="Successful bid"
            else:
                info="Unsuccessful bid"

        return render_template('trader.html', \
                            domain=DOMAIN, \
                            username=username, \
                            sold_Data=sold_Data, \
                            info=info)
    elif session['username'] != username:
        return "Page Not Found!"


@app.route('/<username>/farmer/notifications', methods=['GET','POST'])
def farmer_notifications(username):
    if session['username']==username:
        farmer_notif = farmer_notification(username)
        info=""

        if request.method=='POST':
            crop_request_entry = request.form['crop_request_entry']
            src_person = username
            dest_person = request.form['dest_person']
            w_price = request.form['w_price']

            src = extract_userdetails(username)
            des = extract_userdetails(dest_person)

            src_addr = str(src[0][5]) + str(src[0][6])
            src_pin = str(src[0][8])
            dest_addr = str(des[0][5]) + str(des[0][6])
            dest_pin = str(des[0][8])

            if send_shipment_request(crop_request_entry,src_person, src_addr, src_pin, w_price, dest_person, dest_addr, dest_pin):
                info="Shipment request made successfully"
            else:
                info="Please try again"

        return render_template('notifications.html',
                                    domain=DOMAIN,
                                    username=username,
                                    farmer_notif=farmer_notif,
                                    info=info)
    else:
        return "Fail"

@app.route('/<username>/trader/notifications', methods=['GET'])
def trader_notifications(username):
    return render_template('notifications.html',
                                domain=DOMAIN,
                                username=username)

@app.route('/<username>/farmer/sell',methods = ['GET','POST'])
def sell(username):
    if session['username']==username:
        crop_details = extract_hirvestedcrop(username)
        pin_area = extract_area()
        info=""

        if request.method=='POST':
            phone_no = username
            req_type = 'S'
            crop_id = request.form['crop_id']
            req_pin = request.form['req_pin']
            crop_weight = request.form['crop_weight']
            entry_time = strftime("%d-%m-%Y", gmtime())
            notes = request.form['notes']

            if sellCrop(phone_no, req_type, crop_id, req_pin, crop_weight, entry_time, notes):
                info="Request executed successfully"
            else:
                info="Please try again"

        return render_template('sell.html',
                                domain=DOMAIN,
                                username=username,
                                crop_details=crop_details,
                                pin_area_tuple=pin_area,
                                info=info)        
    else:
        return render_template('sell.html')

@app.route('/<username>/farmer/warehouse',methods = ['GET','POST'])
def warehouse(username):
    if session['username']==username:
        return render_template('warehouse.html',
                                domain=DOMAIN,
                                username=username)        
    else:
        return redirect(DOMAIN)

@app.route('/<username>/farmer/q_a',methods = ['GET','POST'])
def q_a(username):
    if session['username']==username:
        return render_template('q_a.html',
                                domain=DOMAIN,
                                username=username)        
    else:
        return redirect(DOMAIN)


@app.route('/<username>/<type>/crop',methods = ['GET','POST'])
def crop(username, type):
    if type!="farmer":
        weather_data = getWeatherData()
        return render_template('farmer.html', \
                            domain=DOMAIN, \
                            username=username, \
                            weatherdata=weather_data)

    if session['username'] == username:
        crop_details = extract_crop()
        pin_area = extract_area()
        info=""

        if request.method=='POST':
            phone_no = username
            land_size = request.form['land_size']
            land_pin = request.form['land_pin']
            crop_var_id = request.form['crop_var_id']
            land_owner_phone = request.form['land_owner_phone']
            plant_date = request.form['plant_date']
            crop_harvest_date = request.form['crop_harvest_date']
            organic_certified = ''
            weight_after_harvest = request.form['weight_after_harvest']
            quality_certi = request.form['quality_certi']
            quality_certi_date = request.form['quality_certi_date']

            if insertCropDetails(phone_no, land_size, land_pin, land_owner_phone, crop_var_id, \
            plant_date, crop_harvest_date, organic_certified, weight_after_harvest, quality_certi,\
            quality_certi_date):
                info="Crop Details added successfully"
            else:
                info="Please try again"

        return render_template('crop.html',
                                domain=DOMAIN,
                                username=username,
                                crop_details=crop_details,
                                pin_area_tuple=pin_area,
                                info=info)
    elif session['username'] != username:
        return "Page Not Found!"

if __name__=="__main__":
    app.run(host = '0.0.0.0', port=8080, threaded=True)