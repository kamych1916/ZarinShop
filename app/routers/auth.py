from fastapi import APIRouter
import random
from starlette import status
from services.email import*
from services.auth import*
from starlette.requests import Request
from models.auth import userSignup,userSignin
from config import auth, email

router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop


@router.post("/api/v1/signin")
async def login(user_sign_in: userSignin, response: Response):
    if not authenticate_user(user_sign_in):
        raise HTTPException(status_code=401)
    users_collection = db.users
    access_token_expires = timedelta(minutes=auth.Config.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": str(users_collection.find_one({'email': user_sign_in.email})['_id'])},
        expires_delta=access_token_expires)
    response.status_code = status.HTTP_200_OK
    ##response.headers["Authorization"] ="Bearer " + access_token
    response.set_cookie(key="session_token", value=access_token)
    ##response.set_cookie(key="session_token", value=f"Bearer {access_token})
    user = get_current_user(user_sign_in.email)
    auth_users = {
        "id": user.id,
        "first_name": user.first_name,
        "last_name": user.last_name,
        "email": user.email,
        "session_token": access_token
    }
    return auth_users


@router.post("/api/v1/signup")
async def registration_user(new_user: userSignup, response: Response):
    users_collection = db.users
    user = users_collection.find_one({"email": new_user.email})
    if user:
        if user['is_active']:
            raise HTTPException(status_code=403)
        users_collection.remove({"_id": user['_id']})
    hasp_password = hashlib.pbkdf2_hmac('sha256', new_user.password.encode('utf-8'), auth.Config.SECRET_KEY_PASSWORD, 100000)
    try:
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    code = str(random.randint(1000, 9999))
    new_userbd = {
        '_id': l + 1,
        'first_name': new_user.first_name,
        'last_name': new_user.last_name,
        'email': new_user.email,
        'password': auth.Config.SECRET_KEY_PASSWORD + hasp_password,
        'is_active': False,
        'code': code,
        'doe_pwd': ""
    }
    users_collection = db.users
    users_collection.insert_one(new_userbd)
    response.status_code = status.HTTP_201_CREATED
    await send_mes(new_user.email, email.Config.EMAIL_TEXT + code)
    return get_current_user(new_user.email)


@router.delete("/api/v1/logout")
async def logout(response: Response):
    response.delete_cookie(key="session_token")
    return

@router.get("/api/v1/is_admin")
async def is_admin(response: Response, request: Request):
    user = check_auth_user(response, request)
    if user['_id'] in auth.Config.ADMIN_LIST:
        return True
    else:
        return False


@router.get("/api/v1/is_login")
async def is_login(response: Response, request: Request):
    user = check_auth_user(response, request)
    return get_current_user(user['email'])

@router.get("/api/v1/reset_password")
async def pwd(email: str, response: Response):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    if not current_user:
        raise HTTPException(status_code=403)
    if not current_user['is_active']:
        raise HTTPException(status_code=403)
    code = str(random.randint(1000, 9999))
    users_collection.update_one({"email": email}, {"$set": {"code_pwd": code}})
    response.status_code = status.HTTP_201_CREATED
    await send_mes(email, auth.Config.EMAIL_TEXT_PWD + code)
    return get_current_user(email)


@router.post("/api/v1/change_password")
async def change_password(code: str, new_password, email: str, response: Response):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    if not current_user:
        raise HTTPException(status_code=403)
    if current_user['code_pwd'] != code:
        raise HTTPException(status_code=401)
    hasp_password = hashlib.pbkdf2_hmac('sha256', new_password.encode('utf-8'), Config.SECRET_KEY_PASSWORD, 100000)
    users_collection.update_one({"_id": current_user['_id']},
                                {"$set": {"code_pwd": "", "password": Config.SECRET_KEY_PASSWORD + hasp_password}})
    response.status_code = status.HTTP_200_OK
    return HTTPException(status_code=200)


@router.get("/api/v1/checkcode_activ")
async def check_code(code: str, email: str, response: Response):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    if not current_user:
        raise HTTPException(status_code=403)
    if current_user['code'] != code:
        raise HTTPException(status_code=401)
    users_collection.update_one({"_id": current_user['_id']}, {"$set": {"is_active": True, "code": ""}})
    response.status_code = status.HTTP_200_OK
    return HTTPException(status_code=200)
