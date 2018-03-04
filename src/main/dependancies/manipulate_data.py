from connectDB import connectionMYSQL
from weather import Weather

weather = Weather()

def getWeatherData():
    # Lookup via location name.
    location = weather.lookup_by_location('Gujarat, India')
    condition = location.condition()
    print(condition.text())

    # Get weather forecasts for the upcoming days.
    forecasts = location.forecast()[:5]
    data = []
    for forecast in forecasts:
        data.append([forecast.text(), \
                    forecast.date(), \
                    forecast.high(), \
                    forecast.low()])
    return data

def insertOccupation(phone_no, id):
    query = "INSERT INTO user_occupation (phone_no, \
                                occupation_id)" \
            " VALUES(%s,%s)"

    values = (phone_no, id)
    isSuccess = True
    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        conn.commit()
    else:
        isSuccess = False
    
    return isSuccess

def extract_area():
    query = "select pin, area_name from area"

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query)
        l = cursor.fetchall()
        return l
    else:
        return []

def extract_crop():
    query = "select * from crop_variety"

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query)
        l = cursor.fetchall()
        return l
    else:
        return []

def extract_hirvestedcrop(phone_no):
    query="select a.crop_var_id, a.crop_name, a.crop_type from crop_variety as a \
    join (select crop_id from crop_plant_event where phone_no=%s) \
    as e where e.crop_id=a.crop_var_id"

    values = (phone_no,)

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        l = cursor.fetchall()
        return l
    else:
        return []


def extract_state():
    query = "select state_name from states"

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query)
        l = cursor.fetchall()
        return l
    else:
        return []

def extract_occupations(phone_no):
    query = "select occupation_id,occupation_name from occupation natural join user_occupation \
    where occupation.occupation_id=user_occupation.occupation_id and phone_no=%s"

    values = (phone_no,)

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        l = cursor.fetchall()
        return l
    else:
        return []

def extract_remain_occupations(phone_no):
    query = "select occupation_name from occupation where occupation_name not in \
    (select occupation_name from occupation natural join user_occupation where \
    occupation.occupation_id=user_occupation.occupation_id and phone_no=%s)"

    values = (phone_no,)

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        l = cursor.fetchall()
        return l
    else:
        return []

def insertLogisticsDetails(person_id, name, pin):
    query = "INSERT INTO logistics_company (company_person, \
                                company_name, \
                                company_pin)" \
            " VALUES(%s,%s,%s)"
    
    values = (person_id, name, pin)

    query_2 = "INSERT INTO user_occupation (phone_no, \
                                occupation_id)" \
            " VALUES(%s,%s)"
    
    values_2 = (person_id, '03')

    isSuccess = True

    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        conn.commit()
        cursor.execute(query_2, values_2)
        conn.commit()
    else:
        isSuccess = False
    
    return isSuccess

def insertCropDetails(phone_no, land_size, land_pin, land_owner_phone, crop_var_id, \
            plant_date, crop_harvest_date, organic_certified, weight_after_harvest, quality_certi,\
            quality_certi_date):
    query = "INSERT INTO crop_plant_event (phone_no, \
                                land_size, \
                                land_pin, \
                                land_owner_phone, \
                                crop_var_id, \
                                plant_date, \
                                crop_harvest_date, \
                                organic_certified, \
                                weight_after_harvest, \
                                quality_certi, \
                                quality_certi_date)" \
            " VALUES(%s,%s, %s,%s,%s,STR_TO_DATE(%s,'%d-%m-%Y'),\
            STR_TO_DATE(%s,'%d-%m-%Y'),%s,%s,%s,STR_TO_DATE(%s,'%d-%m-%Y'))"    

    values = (phone_no, land_size, land_pin, land_owner_phone, crop_var_id, \
            plant_date, crop_harvest_date, organic_certified, weight_after_harvest, quality_certi,\
            quality_certi_date)
    
    isSuccess = True
    conn = connectionMYSQL()
    if conn.is_connected():
        cursor = conn.cursor()
        cursor.execute(query, values)
        conn.commit()
    else:
        isSuccess = False
    
    return isSuccess    

if __name__=="__main__":
    print extract_area()
    print extract_occupations('9409611733')
    print extract_remain_occupations('9409611733')
    print getWeatherData()