import mysql.connector
from mysql.connector import Error
import datetime, json

# Connect to MYSQL database
def connectionMYSQL():
    return mysql.connector.connect(host='localhost', \
                                port='3306', \
                                database='agro_system', \
                                user='root', \
                                password='123')