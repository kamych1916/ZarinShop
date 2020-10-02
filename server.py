import hashlib
import uuid
from typing import Optional

from jose import JWTError, jwt
from fastapi import FastAPI, HTTPException
from fastapi import Response
import json
from pymongo import MongoClient
from datetime import datetime, timedelta

from starlette import status

import models

app = FastAPI()
client = MongoClient('localhost', 27017, username='', password='')
db = client.zarinshop
SECRET_KEY = "yixozKubgLhKyEpO8WOjvKfxRk7JauP3PMxv2uWfonCEyzEct2J5SaMvm1WpDfks"
SECRET_KEY_PASSWORD = b'\x95\x08\xbbGn\x97\xce\x8c\xb4w\xe84p\x90$\x9aU\xa6\x0cpqF\xb0\x11\xc9\x9a\x18JJ@\xec\xc0'
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def authenticate_user(user: models.userSignin):
    users_collection = db.users
    usermongo = users_collection.find_one({"email": user.email})
    if not usermongo:
        return False
    hasp_password = hashlib.pbkdf2_hmac('sha256', user.password.encode('utf-8'), SECRET_KEY_PASSWORD, 100000)
    if usermongo['password'] == SECRET_KEY_PASSWORD+hasp_password:
        return True
    else:
        return False

def get_current_user(email: str):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    print(current_user)
    user = models.user(id=current_user['_id'], email=current_user['email'])
    user.first_name = current_user['first_name']
    user.last_name = current_user['last_name']
    return user

#-----------------------------------авторизация--------------------------
@app.post("/signin")
async def login(user_sign_in: models.userSignin, response: Response):
    if not authenticate_user(user_sign_in):
        raise HTTPException(status_code=401)
    users_collection = db.users
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": users_collection.find_one({'email':user_sign_in.email})['_id']},
                                       expires_delta=access_token_expires)
    response.status_code = status.HTTP_200_OK
    response.set_cookie(key="session_token", value=access_token)
    return get_current_user(user_sign_in.email)

@app.post("/signup")
async def registration_user(new_user: models.userSignup, response: Response):
    users_collection = db.users
    if users_collection.find_one({"email": new_user.email}):
        raise HTTPException(status_code=403)
    hasp_password = hashlib.pbkdf2_hmac('sha256',new_user.password.encode('utf-8'),SECRET_KEY_PASSWORD,100000)
    new_userbd = {
        '_id': str(uuid.uuid4().hex),
        'first_name': new_user.first_name,
        'last_name': new_user.last_name,
        'email': new_user.email,
        'password': SECRET_KEY_PASSWORD+hasp_password,
    }
    users_collection = db.users
    users_collection.insert_one(new_userbd)
    response.status_code = status.HTTP_201_CREATED
    return get_current_user(new_user.email)

@app.delete("/logout")
async def logout(response: Response):
    response.delete_cookie(key="session_token")
    return

#--------------------------------------------------категории--------------------------

@app.get("/categories")
async def categories(response: Response):
    users_collection = db.categories_items
    cat = users_collection.distinct("name")
    list_of_categories = {}

    for post in cat:
        list_of_subtype = {}
        subtype=users_collection.find({'name': post})
        for sub in subtype:
            list_of_subtype[sub['subtype']] = {'id':sub['_id']}
        list_of_categories[post] = list_of_subtype
    response.status_code = status.HTTP_200_OK
    return json.dumps(list_of_categories,ensure_ascii=False)



@app.post("/categories")
async def add_categories(new_cat: models.new_categories,response: Response):
    users_collection = db.categories_items
    if users_collection.find_one({"name" : new_cat.name,"subtype":new_cat.subtype}):
        raise HTTPException(status_code=403)
    new_categories = {
        '_id': str(uuid.uuid4().hex),
        'name': new_cat.name,
        'subtype':new_cat.subtype
    }
    users_collection.insert_one(new_categories)
    response.status_code = status.HTTP_201_CREATED
    return new_cat


@app.get("/test")
async def test():

    users_collection = db.Items
    temp=users_collection.find_one({"zxc":"asd"})
    return {"as":temp["zxc"]}

