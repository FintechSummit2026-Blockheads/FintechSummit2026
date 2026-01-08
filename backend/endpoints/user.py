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
    
    return getAuth(email, password)

def login(email, password):
    res = find_one_collection({"email": email, "password": password}, "users")
    if res == None:
        print("Password doesnt match or no user found")
        return format_error_msg("Password doesnt match or no user found")
    else:
        print("Login Successful")
        return format_success_msg({"access": True})

@router.post("/register")
async def registerRequest(request: Request):
    email, name, photo, description, dateIDs, matches, password, error = await read_json(request, 
        [
        "email", "name", "photo", "description", "dateIDs", "matches", "password", 
        ]
        )
    if error:
        return format_error_msg(error)
    res = register(email, name, photo, description, dateIDs, matches, password)
    return res

def register(email, name, photo, description, dateIDs, matches, password):
    usr_jsn =  {"email": email,
                "name": name,
                "photo": photo,
                "description": description,
                "dateIDs": dateIDs,
                "matches": matches,
                "password": password,
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

register("1", "name", "photo", "description", [1,2,3], [1,2,3], "6")
login("1", "6")
getProfile("1")