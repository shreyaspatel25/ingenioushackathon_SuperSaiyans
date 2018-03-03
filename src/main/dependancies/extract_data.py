from connectDB import connectionMYSQL

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

if __name__=="__main__":
    print extract_area()
    print extract_occupations('9409611733')