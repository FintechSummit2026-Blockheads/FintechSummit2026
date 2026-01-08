from fastapi import APIRouter, Request
from database.database import find_one_collection, add_to_collection, update_to_collection, delete_from_collection, remove_field_from_collection
from misc.misc import read_json, format_error_msg, format_success_msg, generate_unique_6_digit, generate_unique_8_digit
import hashlib
import random
import string
import asyncio

router = APIRouter()

@router.post("/createDate")
async def createDateRequest(request: Request):
    a_email,
    b_email,
    stake,
    restaurant_email,
    deadline,
    error = await read_json(request, [
        "a_email",
        "b_email",
        "stake",
        "restaurant_email",
        "deadline"])

    if error:
        return format_error_msg(error)
    return createDate(date_id,
        a_email,
        b_email,
        stake,
        restaurant_email,
        deadline)

def createDate(
    date_id,
    a_email,
    b_email,
    stake,
    restaurant_email,
    deadline):
    personA = find_one_collection({"email": a_email}, "users")
    personB = find_one_collection({"email": b_email}, "users")
    restaurant = find_one_collection({"email": restaurant_email}, "restaurants")

    a_pubkey = personA["pubkey"]
    b_pubkey = personB["pubkey"]
    restaurant_pubkey = restaurant["pubkey"]

    date_id = str(generate_unique_8_digit())
    secA = str(generate_unique_6_digit())
    secB = str(generate_unique_6_digit())

    condA = hashlib.sha256(secA.encode('utf-8')).hexdigest()
    condB = hashlib.sha256(secB.encode('utf-8')).hexdigest()

    encSecA = encrypt_with_xrp_pubkey(a_pubkey, secA.encode('utf-8'))
    encSecB = encrypt_with_xrp_pubkey(b_pubkey, secB.encode('utf-8'))

    date_jsn =  {
        "date_id": date_id,
        "a_pubkey": a_pubkey,
        "b_pubkey": b_pubkey,
        "a_email": a_email,
        "b_email": b_email,
        "stake": stake,
        "restaurant_pubkey": restaurant_pubkey,
        "restaurant_email": restaurant_email,
        "deadline": deadline,
        "secA": encSecA,
        "secB": encSecB,
        "condA": condA,
        "condB": condB,
        "seqA": -1,
        "seqB": -1, 
        "iconfirmd": False 
    }
    date = add_to_collection(date_jsn, "dates")
    return format_success_msg({"access": True, "date_id": date_id})

@router.post("/getDate")
async def getDateRequest(request: Request):
    date_id, error = await read_json(request, ["date_id"])
    if error:
        return format_error_msg(error)
    return getDate(date_id)

def getDate(date_id):
    date = find_one_collection({"date_id": date_id}, "dates")

    if date != None:
        return format_success_msg({"date": date})
    else:
        return format_error_msg("No date found with this ID")

@router.post("/acceptDate")
async def acceptDateRequest(request: Request):
    person_email,
    date_id,
    seq, error = await read_json(request, [
        "person_email",
        "date_id",
        "seq"])
    if error:
        return format_error_msg(error)
    return acceptDate(person_email, date_id, seq)

# Request seq from blockchain script that was run in frontend
def acceptDate(person_email, date_id, seq):
    date = find_one_collection({"date_id": date_id}, "dates")

    if person_email == date["a_email"]:
        update_to_collection(
            {"date_id": date_id},
            {
                "seqA": seq,
            },
            "dates")
        return format_success_msg({})
    elif person_email == date["b_email"]:
        update_to_collection(
            {"date_id": date_id},
            {
                "seqB": seq,
            },
            "dates")
        return format_success_msg({})
    else:
        return format_error_msg("No date found with this ID")

@router.post("/rejectDate")
async def rejectDateRequest(request: Request):
    date_id, error = await read_json(request, ["date_id"])
    if error:
        return format_error_msg(error)
    return rejectDate(date_id)

def rejectDate(date_id):
    delete_from_collection({"date_id": date_id}, "dates")
    return format_success_msg({"message": "Date rejected and deleted successfully"})

@router.post("confirmDate")
async def confirmDateRequest(request: Request):
    date_id, error = await read_json(request, ["date_id"])
    if error:
        return format_error_msg(error)
    return confirmDate(date_id)

def confirmDate(date_id):
    update_to_collection(
        {"date_id": date_id},
        {
            "isCompleted": True,
        },
        "dates")
    return format_success_msg({})


@router.post("/arrive")
async def arriveRequest(request: Request):
    email,
    date_id, error = await read_json(request, [
        "email",
        "date_id"])
    if error:
        return format_error_msg(error)
    return arrive(email, date_id)

def arrive(email, date_id):
    date = find_one_collection({"date_id": date_id}, "dates")
    restaurant_pubkey = date["restaurant_pubkey"]
    
    if date["seqA"] != -1 and date["seqB"] != -1:
        if email == date["a_email"]:
            return format_success_msg({"encSec": date["secA"], 
            "seq": date["seqA"], 
            "restaurant_pubkey": restaurant_pubkey})
        elif email == date["b_email"]:
            return format_success_msg({"encSec": date["secB"], 
            "seq": date["seqB"],
            "restaurant_pubkey": restaurant_pubkey})
        else:
            return format_error_msg("No date found with this ID")
    else:
        return format_error_msg("Both parties have not accepted the date yet")

# Testing

# temp = generate_unique_6_digit()
# print(createDate(temp,
#     "abc@mail.com",
#     "1234@m.com",
#     100,
#     "restaurant@123",
#     "deadline",
#     "secA",
#     "secB",
#     "condA",
#     "condB"))
# print(getDate(temp))
# print(acceptDate("abc@mail.com", temp, 5))
# print(acceptDate("1234@m.com", temp, 5678))
# # print(rejectDate(temp))
# printconfirmDate(temp)
# print(getDate(temp))

# temp = 424134

# print(arrive("abc@mail.com", temp))
