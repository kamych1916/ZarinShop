import hashlib
from typing import Optional
from jose import JWTError, jwt
from fastapi import HTTPException

from fastapi import Response
from datetime import datetime, timedelta
from pymongo import MongoClient
from config import auth
from models.auth import userSignin,user
from starlette.requests import Request


client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(to_encode, auth.Config.SECRET_KEY, algorithm=auth.Config.ALGORITHM)
    return encoded_jwt


def authenticate_user(user: userSignin):
    users_collection = db.users
    usermongo = users_collection.find_one({"email": user.email})
    if not usermongo:
        return False
    if not usermongo['is_active']:
        raise HTTPException(status_code=403)
    hasp_password = hashlib.pbkdf2_hmac('sha256', user.password.encode('utf-8'), auth.Config.SECRET_KEY_PASSWORD, 100000)
    if usermongo['password'] == auth.Config.SECRET_KEY_PASSWORD + hasp_password:
        return True
    else:
        return False


def get_current_session_user(token):
    try:
        payload = jwt.decode(token, auth.Config.SECRET_KEY, algorithms=[auth.Config.ALGORITHM])
        username_id: str = payload.get("sub")
    except JWTError:
        raise HTTPException(status_code=401)
    if username_id is None:
        raise HTTPException(status_code=401)
    users_collection = db.users
    user = users_collection.find_one({'_id': int(username_id)})
    if user is None:
        raise HTTPException(status_code=401)
    return user


def get_current_user(email: str):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    user_models = user(id=current_user['_id'], email=current_user['email'])
    user_models.first_name = current_user['first_name']
    user_models.last_name = current_user['last_name']
    return user_models


def check_auth_user(response: Response, request: Request):
    if (not request.cookies) or ('session_token' not in request.cookies):
        raise HTTPException(status_code=401)
    try:
        user = get_current_session_user(request.cookies.get('session_token'))
        return user
    except JWTError:
        raise HTTPException(status_code=401)

def check_auth_user_middleware(request: Request):
    if (not request.cookies) or ('session_token' not in request.cookies):
        return True
    if (str(request.url).replace(str(request.base_url), "") == "docs") or (((request.method == "POST") or (request.method == "DELETE") or
        (request.method == "PATCH")) and request.url.path in auth.Config.ADMIN_URL):
        try:
            payload = jwt.decode(request.cookies.get('session_token'), auth.Config.SECRET_KEY,
                                 algorithms=[auth.Config.ALGORITHM])
            username_id: str = payload.get("sub")
            if username_id is None:
                return False
            users_collection = db.users
            user = users_collection.find_one({'_id': int(username_id)})
            if user is None:
                return False
            if user['_id'] not in auth.Config.ADMIN_LIST:
                return False
        except JWTError:
            return False
    return True

    '''
        
        
        if request.url.path in auth.Config.ADMIN_URL:
        try:
            payload = jwt.decode(request.cookies.get('session_token'), auth.Config.SECRET_KEY, algorithms=[auth.Config.ALGORITHM])
            username_id: str = payload.get("sub")
        except JWTError:
            return False
        if username_id is None:
            return False
        users_collection = db.users
        user = users_collection.find_one({'_id': int(username_id)})
        if user is None:
            return False
        if (str(request.url).replace(str(request.base_url), "") == "docs"):
            if user['_id'] not in auth.Config.ADMIN_LIST:
                return False
        if ((request.method == "POST") or (request.method == "DELETE") or
            (request.method == "PATCH")) and request.url.path in auth.Config.ADMIN_URL:
            if user['_id'] not in auth.Config.ADMIN_LIST:
                return False
        return True
        return True
    except JWTError:
        return True'''

