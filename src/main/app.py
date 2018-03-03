# Python dependancies
import os
import sys
import socket

# Import Dependancies 
reload(sys)
sys.path.append('./dependancies/')
sys.setdefaultencoding('utf-8')

from flask import Flask, render_template, request, redirect, session
from connectDB import connectionMYSQL

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
            return render_template('signup.html')
    elif request.method == 'POST':
        
        email = request.form['email']
        username = request.form['username']
        password = request.form['password']
        confirmpassword = request.form['confirmPassword']

        errors = validateRegistration(email,username,password,confirmpassword);

        if len(errors) == 0:
            m = hashlib.sha256()
            #d = bytes(str(datetime.datetime.now()),'utf-8')
            d = bytes(str(datetime.datetime.now()))
            m.update(d)
            key = m.hexdigest()
            isSuccess = register(email,username,password,key)
            body = "Click on the following link to activate your account..! \n" \
                     + domain + "activate" + "?email=" + email + "&id=" + key
            subject = "Activate Your Account"
            mail(email,body,subject)    
            if isSuccess:
                return redirect(domain + "congratulation?success=register", code=302)
            else:
                return "Error"
        else:
            return render_template('SignUp.html',errors = errors)

    return render_template('signup.html')

if __name__=="__main__":
    app.run(host = '0.0.0.0', port=8080, threaded=True)