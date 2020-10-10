import hashlib
import random
import uuid
from typing import Optional
import smtplib
from jose import JWTError, jwt
from fastapi import FastAPI, HTTPException
from fastapi import Response
import json
from pymongo import MongoClient
from datetime import datetime, timedelta
from email.mime.text import MIMEText
from email.header    import Header
from starlette import status
import models
from config import Config
app = FastAPI()
# изменить структуру категориии добавления товара 


client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop
#app.add_middleware(
  #  CORSMiddleware,
  #  allow_origins=["*"],
  #  allow_credentials=True,
  #  allow_methods=["*"],
 #   allow_headers=["*"],
#)



def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, Config.SECRET_KEY, algorithm=Config.ALGORITHM)
    return encoded_jwt


def authenticate_user(user: models.userSignin):
    users_collection = db.users
    usermongo = users_collection.find_one({"email": user.email})
    if not usermongo:
        return False
    if not usermongo['is_active']:
        return False
    hasp_password = hashlib.pbkdf2_hmac('sha256', user.password.encode('utf-8'), Config.SECRET_KEY_PASSWORD, 100000)
    if usermongo['password'] == Config.SECRET_KEY_PASSWORD + hasp_password:
        return True
    else:
        return False


def get_current_user(email: str):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    user = models.user(id=current_user['_id'], email=current_user['email'])
    user.first_name = current_user['first_name']
    user.last_name = current_user['last_name']
    return user


async def send_mes(email: str, text: str):
    server = smtplib.SMTP_SSL('smtp.mail.ru', 465)
    server.login(Config.LOGIN_EMAIL, Config.PASSWORD_EMAIL)
    msg =MIMEText(text, 'plain', 'utf-8')
    msg['Subject'] = Header('Подтверждение действий', 'utf-8')
    msg['From'] = Config.LOGIN_EMAIL
    msg['To'] = email
    server.sendmail(Config.LOGIN_EMAIL, email, msg.as_string())
    server.quit()


# -----------------------------------авторизация--------------------------


@app.post("/api/v1/signin")
async def login(user_sign_in: models.userSignin, response: Response):
    if not authenticate_user(user_sign_in):
        raise HTTPException(status_code=401)
    users_collection = db.users
    access_token_expires = timedelta(minutes=Config.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": users_collection.find_one({'email': user_sign_in.email})['_id']},
                                       expires_delta=access_token_expires)
    response.status_code = status.HTTP_200_OK
    response.set_cookie(key="session_token", value=access_token)
    return get_current_user(user_sign_in.email)


@app.post("/api/v1/signup")
async def registration_user(new_user: models.userSignup, response: Response):
    users_collection = db.users

    if users_collection.find_one({"email": new_user.email}):
        raise HTTPException(status_code=403)
    hasp_password = hashlib.pbkdf2_hmac('sha256', new_user.password.encode('utf-8'), Config.SECRET_KEY_PASSWORD, 100000)
    u = list(users_collection.find().sort('_id', -1).limit(1))
    ind = 1
    if u:
        ind = int(u[0]['_id'])+1
    code = str(random.randint(1000, 9999))
    new_userbd = {
        '_id': ind,
        'first_name': new_user.first_name,
        'last_name': new_user.last_name,
        'email': new_user.email,
        'password': Config.SECRET_KEY_PASSWORD + hasp_password,
        'is_active': False,
        'code': code,
        'doe_pwd':""
    }
    users_collection = db.users
    users_collection.insert_one(new_userbd)
    response.status_code = status.HTTP_201_CREATED
    await send_mes(new_user.email, Config.EMAIL_TEXT + code)
    return get_current_user(new_user.email)


@app.delete("/api/v1/logout")
async def logout(response: Response):
    response.delete_cookie(key="session_token")
    return


@app.get("/api/v1/reset_password")
async def pwd(email:str, response: Response):
    users_collection = db.users
    current_user = users_collection.find_one({"email": email})
    if not current_user:
        raise HTTPException(status_code=403)
    code = str(random.randint(1000, 9999))
    users_collection.update_one({"email":email},{"$set":{"code_pwd":code}})
    response.status_code = status.HTTP_201_CREATED
    await send_mes(email, Config.EMAIL_TEXT_PWD + code)
    return get_current_user(email)

@app.post("/api/v1/change_password")
async def change_password(code:str,new_password,email:str,response: Response):
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



@app.get("/api/v1/checkcode_activ/{code}")
async def check_code(code:str,email:str,response: Response):
    users_collection = db.users
    current_user = users_collection.find_one({"email":email})
    if not current_user:
        raise HTTPException(status_code=403)
    if current_user['code'] != code:
        raise HTTPException(status_code=401)
    users_collection.update_one({"_id" : current_user['_id']}, {"$set" : {"is_active":True, "code":""}})
    response.status_code = status.HTTP_200_OK
    return HTTPException(status_code=200)

# --------------------------------------------------категории--------------------------

@app.get("/api/v1/categories")
async def categories(response: Response):
    users_collection = db.categories_items
    cat = users_collection.find()
    list_of_categories = []

    for post in cat:
        models.cat(id=post['_id'],name=post['name'],subcategories=[])

        print(list_of_categories)
    response.status_code = status.HTTP_200_OK
    return json.dumps(list_of_categories, ensure_ascii=False)


@app.post("/api/v1/categories")
async def add_categories(new_cat: models.new_categories, response: Response):
    users_collection = db.categories_items
    if users_collection.find_one({"name": new_cat.main, "subtype": new_cat.subtype,"lasttype":new_cat.lasttype}):
        raise HTTPException(status_code=403)
    u = list(users_collection.find().sort('_id', -1).limit(1))
    ind = 1
    if u:
        ind = int(u[0]['_id']) + 1
    new_categories = {
        '_id': ind,
        'name': new_cat.main,
        'subtype': new_cat.subtype,
        'lasttype': new_cat.lasttype
    }
    users_collection.insert_one(new_categories)
    response.status_code = status.HTTP_201_CREATED
    return new_cat


@app.patch("/api/v1/categories")
async def edit_categories(id: str, edit_cat: models.patch_categories, response: Response):
    users_collection = db.categories_items
    current_cat = users_collection.find_one({"_id": id})
    if current_cat:
        raise HTTPException(status_code=403)
    if edit_cat.subtype:
        users_collection.update_one({'_id': id}, {'$set': {'subtype': edit_cat.subtype}})
    response.status_code = status.HTTP_200_OK
    return models.categories(id=id, name=current_cat['name'], subtype=categories['subtype'])
#-------------------------------ТОВАРЫ----------------------------------
@app.post("/api/v1/items")
async def add_items(new_item:models.add_items, response: Response):
    users_collection = db.items
    u = list(users_collection.find().sort('_id', -1).limit(1))
    ind = 1
    if u:
        ind = int(u[0]['_id']) + 1
    new_item={
        '_id': ind,
        "name": new_item.name,
        "description": new_item.description,
        "image": new_item.image,
        "price": new_item.price,
        "discount": new_item.discount,
        "hit_sales": new_item.hit_sales,
        "special_offer": new_item.special_offer,
        "categories": new_item.categories
    }
    users_collection.insert_one(new_item)
    response.status_code = status.HTTP_200_OK
    return new_item

@app.get("/api/v1/items")
async def get_items(response: Response):
    users_collection = db.items
    all_items = users_collection.find()
    a_i={}
    for post in all_items:
        a_i[post['_id']] = post
    response.status_code = status.HTTP_200_OK
    return  json.dumps(a_i)

#--------------сделать
@app.patch("/api/v1/items")
async def patch_items(patch_item:models.patch_items,response: Response):
    users_collection = db.items
    current_item = users_collection.find_one({'_id':patch_item.id})
    if not current_item:
        raise HTTPException(status_code=403)
    return

@app.delete("/api/v1/items")
async def delete_items(id:str):
    users_collection = db.items
    users_collection.remove({"_id":id})
    return HTTPException(status_code=200)




#--------------------------------------ПОИСК ТОВАРА----------------
@app.get("/api/v1/search")
async def search(poisk:str,response: Response):
    users_collection = db.categories_items
    list_of_cat=users_collection.find({"name":{'$regex':poisk}})
    item_collection= db.items
    list_items={}
    if list_of_cat:
        for post in list_of_cat:
            for i in item_collection.find({"categories":post['_id']}):
                new_item = {
                    "name": i['name'],
                    "description": i['description'],
                    "image": i['image'],
                    "price": i['price'],
                    "discount": i['discount'],
                    "hit_sales": i['hit_sales'],
                    "special_offer": i['special_offer'],
                    "categories": i['categories']
                }
                list_items[i['_id']] = new_item
        if list_items:
            return json.dumps(list_items)
    list_of_cat = users_collection.find({"subtype": {'$regex': poisk}})
    if list_of_cat:
        for post in list_of_cat:
            for i in item_collection.find({"categories":post['_id']}):
                new_item = {
                    "name": i['name'],
                    "description": i['description'],
                    "image": i['image'],
                    "price": i['price'],
                    "discount": i['discount'],
                    "hit_sales": i['hit_sales'],
                    "special_offer": i['special_offer'],
                    "categories": i['categories']
                }
                list_items[i['_id']]=new_item
        if list_items:
            return json.dumps(list_items)
    list_of_cat = users_collection.find({"lasttype": {'$regex': poisk}})
    if list_of_cat:
        for post in list_of_cat:
            for i in item_collection.find({"categories": post['_id']}):
                new_item = {
                    "name": i['name'],
                    "description": i['description'],
                    "image": i['image'],
                    "price": i['price'],
                    "discount": i['discount'],
                    "hit_sales": i['hit_sales'],
                    "special_offer": i['special_offer'],
                    "categories": i['categories']
                }
                list_items[i['_id']] = new_item
        if list_items:
            return json.dumps(list_items)
    for i in item_collection.find({"name": {'$regex': poisk}}):
        new_item = {
            "name": i['name'],
            "description": i['description'],
            "image": i['image'],
            "price": i['price'],
            "discount": i['discount'],
            "hit_sales": i['hit_sales'],
            "special_offer": i['special_offer'],
            "categories": i['categories']
        }
        list_items[i['_id']] = new_item
    return json.dumps(list_items)

@app.get("/api/v1/test")
async def test():
    users_collection = db.Items
    temp = users_collection.find_one({"zxc": "asd"})
    return {"as": temp["zxc"]}
