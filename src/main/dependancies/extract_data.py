from connectDB import connectionMYSQL
from weather import Weather

weather = Weather()

def getWeatherData():
    # Lookup via location name.

    location = weather.lookup_by_location('Gujarat, India')
    condition = location.condition()
    print(condition.text())

    # Get weather forecasts for the upcoming days.
    forecasts = location.forecast()[:1]
    for forecast in forecasts:
        print(forecast.text())
        print(forecast.date())
        print(forecast.high())
        print(forecast.low())

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

if __name__=="__main__":
    print extract_area()
    print extract_occupations('9409611733')
    print extract_remain_occupations('9409611733')
    print getWeatherData()