from connectDB import connectionMYSQL

def auth_login(phone_no, password):
    query = "select exists(select * from users where phone_no=%s and password=%s)"
    values = (phone_no, password)

    isSuccess = False

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        l = cursor.fetchone()
        if l[0]==1:
            isSuccess=True
    else:
        isSuccess = False

    return isSuccess

def registration(user_data):
    query = "INSERT INTO users (phone_no, \
                                password, \
                                first_name, \
                                last_name, \
                                email_id, \
                                address_line_1, \
                                address_line_2, \
                                gender, \
                                pin, \
                                dob, \
                                aadhar_no, \
                                online_status)" \
            " VALUES(%s,%s, %s,%s,%s,%s,%s,%s,%s,STR_TO_DATE(%s,'%d-%m-%Y'),%s,%s)"

    print user_data
    values = (user_data['phone_no'], user_data['password'],user_data['first_name'],user_data['last_name'],\
            user_data['email_id'], user_data['address_line_1'], user_data['address_line_2'],\
            user_data['gender'],user_data['pin'],user_data['dob'],user_data['aadhar_no'],\
            user_data['online_status'])
    isSuccess = True

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        conn.commit()
    else:
        isSuccess = False

    return isSuccess