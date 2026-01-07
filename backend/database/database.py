from pymongo import MongoClient
import os
from dotenv import load_dotenv

# Returns a client
def init_pymongo():
    global dbname
    load_dotenv()
    uri = os.getenv("PYMONGO_API_KEY")
    dbname = os.getenv("DB_NAME")
    client = MongoClient(uri)
    return client

def close_client(client):
    client.close()

# Returns Collection
def open_collection(name, client):
    db = client[dbname]
    collection = db[name]
    return collection

def find_one_collection(query, colname):
    try:
        client = init_pymongo()
        col = open_collection(colname, client)
        obj = col.find_one(query)
        close_client(client)
        return obj
    except Exception as e:
        print("cannot find data")
        return None

def add_to_collection(item, colname):
    client = init_pymongo()
    col = open_collection(colname, client)
    obj = col.insert_one(item)
    close_client(client)
    return obj

def delete_from_collection(item, colname):
    client = init_pymongo()
    col = open_collection(colname, client)
    obj = col.delete_one(item)
    close_client(client)
    return obj

# Note this is to add a new parameter to the query
def update_to_collection(query, item, colname):
    client = init_pymongo()
    col = open_collection(colname, client)
    obj = col.update_one(query, {"$set": item})
    close_client(client)
    return obj

# Note this is to add a new parameter to the query
def add_stuff_to_array_to_collection(query, item, colname):
    client = init_pymongo()
    col = open_collection(colname, client)
    obj = col.update_one(query, {"$set": item})
    close_client(client)
    return obj

def remove_field_from_collection(query, item, colname):
    client = init_pymongo()
    col = open_collection(colname, client)
    obj = col.update_one(query, {"$unset": item})
    close_client(client)
    return obj