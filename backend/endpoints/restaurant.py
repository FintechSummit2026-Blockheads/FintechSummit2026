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
    email, password, error = await read_json(request, ["email", "password"])
    if error:
        return format_error_msg(error)
    
    return login(email, password)

def login(email, password):
    res = find_one_collection({"email": email, "password": password}, "restaurants")
    if res == None:
        return format_error_msg("Password doesnt match or no user found")
    else:
        return format_success_msg({"access": True})

@router.post("/register")
async def registerRequest(request: Request):
    email, name, pubkey, photo, description, dateIDs, password, error = await read_json(request, 
        [
        "email", "name", "pubkey", "photo", "description", "dateIDs", "password", 
        ]
        )
    if error:
        return format_error_msg(error)
    res = register(email, name, pubkey, photo, description, dateIDs, password)
    return res

def register(email, name, pubkey, photo, description, dateIDs, password):
    restaurant_jsn =  {"email": email,
                "name": name,
                "pubkey": pubkey,
                "photo": photo,
                "description": description,
                "dateIDs": dateIDs,
                "password": password,
                }
    
    res = find_one_collection({"email": email}, "restaurants")

    if res == None:
        usr = add_to_collection(restaurant_jsn, "restaurants")
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
    res = find_one_collection({"email": email}, "restaurants")

    if res != None:
        return format_success_msg({"profile": res})
    else:
        return format_error_msg("No user found with this email")

<<<<<<< HEAD
# register("1", "name", "photo", "description", [1,2,3], [1,2,3], "6")
# login("1", "6")
# getProfile("2")
=======
@router.post("/getDates")
async def getDates(request: Request):
    email, error = await read_json(request, 
        [
        "email"
        ]
        )
    if error:
        return format_error_msg(error)
    res = getDates(email)
                
    return res

def getDates(email):
    res = find_one_collection({"email": email}, "restaurants")

    if res != None:
        date_ids = res["dateIDs"]
        return format_success_msg({"date_ids": date_ids})
    else:
        return format_error_msg("No restaurant found with this email")

print(register("restaurant@123", "restaurant", "key", "photo", "description", [1,2,3], "6"))
print(login("restaurant@123", "6"))
print(getProfile("restaurant@123"))
print(getDates("restaurant@123"))
>>>>>>> main
