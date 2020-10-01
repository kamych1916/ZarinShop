from fastapi import FastAPI
from pymongo import MongoClient
import models

app = FastAPI()
client = MongoClient('localhost', 27017, username='', password='')
db = client.zarinshop





@app.get("/test")
async def test():
    users_collection = db.Items
    temp=users_collection.find_one({"zxc":"asd"})
    return {"as":temp["zxc"]}

