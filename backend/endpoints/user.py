from fastapi import APIRouter, Request
from database.database import find_one_collection, add_to_collection, update_to_collection, delete_from_collection
from misc.misc import read_json, format_error_msg, format_success_msg
import hashlib
import random
import string
import asyncio

router = APIRouter()

@router.post("/login")
async def loginRequest(request: Request):
    name, password, error = await read_json(request, ["name", "password"])
    if error:
        return format_error_msg(error)
    
    return getAuth(name, password)

def login(name, password):
    res = find_one_collection({"name": name, "password": password}, "users")
    if res == None:
        print("Password doesnt match or no user found")
        return format_error_msg("Password doesnt match or no user found")
    else:
        print("Login Successful")
        return format_success_msg({"access": True})

@router.post("/register")
async def registerRequest(request: Request):
    name, email, photo, description, dates, password, public_key, private_key, error = await read_json(request, 
        [
        "name", "email", "photo", "description", "dates", "password",
                "public key", "private key"
        ]
        )
    if error:
        return format_error_msg(error)
    res = register(name, email, photo, description, dates, password,
                public_key, private_key)
    return res

def register(name, email, photo, description, dates, password,
                public_key, private_key):
    usr_jsn =  {"name": name,
                "email": email,
                "photo": photo,
                "description": description,
                "dates": dates,
                "password": password,
                "public key": public_key,
                "private key": private_key
                }
    
    res = find_one_collection({"email": email}, "users")

    if res == None:
        usr = add_to_collection(usr_jsn, "users")
        return format_success_msg({"access": True})
    else:
        return format_error_msg("Username exists in a collection, Please try a different one")

@router.post("/getProfile")
async def registerRequest(request: Request):
    email, error = await read_json(request, 
        [
        "email"
        ]
        )
    if error:
        return format_error_msg(error)
    res = getProfile(email)
                
    return res

def getProfile(email):
    res = find_one_collection({"email": email}, "users")

    if res != None:
        print(res)
        return format_success_msg({"profile": res})
    else:
        return format_error_msg("No user found with this email")

@router.post("/uploadSSID")
async def uploadRequest(request: Request):
    ssid, error = await read_json(request, ["ssid"])
    if error:
        return format_error_msg(error)
    res = uploadSSID(ssid)
    return res

# TODO update this to the database
# Returns True if ssid matches the database / the escrow
# Else updates False
def uploadSSID(ssid):
    return False

@router.post("/getDates")
async def getDatesRequest(request: Request):
    email, error = await read_json(request, ["email"])
    if error:
        return format_error_msg(error)
    res = getDates(email)
    return res

# TODO format the date_object 
def getDates(email):
    res = find_one_collection({"email": email}, "users")
    if res == None:
        print("Not a valid user")
        return format_error_msg("Not a valid user")
    else:
        print(res)
        array_of_dates = res["dateIDs"]
        for date in array_of_dates:
            # date_object = find_one_collection({"date"})
            pass

        # return format_success_msg()


# register("1", "2", "3", "4", "5", "6", "7", "8")
# login("1", "6")
# getProfile("2")
# getDates("1")