from fastapi import APIRouter, Request
from database.database import find_one_collection, add_to_collection, update_to_collection, delete_from_collection, init_pymongo, open_collection
from misc.misc import read_json, format_error_msg, format_success_msg
from pymongo import MongoClient
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
                "pendingMatches": [],
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

# @router.post("/getDates")
# async def getDatesRequest(request: Request):
#     email, error = await read_json(request, ["email"])
#     if error:
#         return format_error_msg(error)
#     res = getDates(email)
#     return res

# # TODO format the date_object 
# def getDates(email):
#     res = find_one_collection({"email": email}, "users")
#     if res == None:
#         print("Not a valid user")
#         return format_error_msg("Not a valid user")
#     else:
#         print(res)
#         dateIds = res["dateIDs"]
        
#         for dateID in dateIds:
#             date_object = find_one_collection({"date"})
#             pass

        # return format_success_msg()

@router.get("/getRandomProfile")
async def getRandomProfileRequest(request: Request):
    res = getRandomProfile()
    return res

def getRandomProfile():
    client = init_pymongo()
    col = open_collection("users", client)
    
    # Get a random profile
    random_doc = col.aggregate([
        {'$sample': {'size': 1}}
    ])

    for doc in random_doc:
        return doc



@router.post("/acceptMatch")
async def postSendInvitationRequest(request: Request):
    emailUser, emailMatch, error = await read_json(request, 
        ["emailUser", 
         "emailMatch"])
    if error:
        return format_error_msg(error)
    res = acceptMatch(emailUser, emailMatch)
    return format_success_msg(res)

def acceptMatch(emailUser, emailMatch):
    userProfile = find_one_collection({"email": emailUser}, "users")
    pendingMatches = userProfile["pendingMatches"]
    for match in pendingMatches:
        if match == emailMatch:
            pendingMatches.remove(emailMatch)
            update_to_collection({"email": emailUser}, {"pendingMatches": pendingMatches}, "users")
            addToMatchedPeopleArrayA(emailUser, emailMatch)
            addToMatchedPeopleArrayA(emailMatch, emailUser)
            return {"access": True}
    pendingMatches.add(emailMatch)
    update_to_collection({"email": emailUser}, {"pendingMatches": pendingMatches}, "users")
    return {"access": True}

def addToMatchedPeopleArrayA(emailA, emailB):
    aProfile = find_one_collection({"email": emailA}, "users")
    matchedPeopleArrayA = aProfile["matches"]
    matchedPeopleArrayA.add(emailB)
    update_to_collection({"email": emailA}, {"matches": matchedPeopleArrayA}, "users")
    

# @router.post("/getPendingMatches")
# async def getPendingMatchesRequest(request: Request):
#     emailUser, error = await read_json(re)
    

# print("Register 1")
# register("1", "2", "3", "4", "5", "6", "7")
# print("Register 123")
# register("123", "2", "3", "4", "5", "6", "7")
# print("Accepting match")
# acceptMatch("1", "123")
# acceptMatch("123", "1")

# login("1", "6")
# getProfile("2")
# getDates("1")