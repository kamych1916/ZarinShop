from fastapi import APIRouter
from fastapi import Response
from pymongo import MongoClient
from starlette.requests import Request
from models.mailing import mailing

router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop



@router.post("/api/v1/add_mailing")
async def add_mailing(new_mailing: mailing):
    mailing_collectoin = db.mailing
    if mailing_collectoin.find_one({"email":new_mailing.email}):
        return
    mailing_collectoin.insert_one({"email":new_mailing.email})
    return new_mailing

@router.get("/api/v1/mailing")
async def get_mailing(response: Response, request: Request):
    mailing_collectoin = db.mailing
    list_email = []
    for post in mailing_collectoin.find():
        list_email.append({"email":post['email']})
    return list_email
