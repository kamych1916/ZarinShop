import hashlib
import os
import random
import shutil
import uuid
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Optional
import smtplib
from jose import JWTError, jwt, jws, JWSError
from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi import Response
import json
from pymongo import MongoClient
from datetime import datetime, timedelta
from email.mime.text import MIMEText
from email.header import Header
from starlette import status
import models
from config import Config
from starlette.requests import Request


app = FastAPI()
# изменить структуру категориии добавления товара 


client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop


# app.add_middleware(
#  CORSMiddleware,
#  allow_origins=["*"],
#  allow_credentials=True,
#  allow_methods=["*"],
#   allow_headers=["*"],
# )


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
    msg = MIMEText(text, 'plain', 'utf-8')
    msg['Subject'] = Header('Подтверждение действий', 'utf-8')
    msg['From'] = Config.LOGIN_EMAIL
    msg['To'] = email
    server.sendmail(Config.LOGIN_EMAIL, email, msg.as_string())
    server.quit()



def get_current_session_user(token):
    try:
        payload = jwt.decode(token, Config.SECRET_KEY,algorithms=[Config.ALGORITHM])
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



def check_auth_user(response: Response, request: Request):
    if (not request.cookies) or ('session_token' not in request.cookies):
        raise HTTPException(status_code=401)
    try:
        user = get_current_session_user(request.cookies.get('session_token'))
        return user
    except JWTError:
        raise HTTPException(status_code=401)

@app.get("/api/v1/is_admin")
async def is_admin(response: Response, request: Request):
    user = check_auth_user(response,request)
    if user['_id'] in Config.ADMIN_LIST:
        return True
    else:
        return False

@app.get("/api/v1/is_login")
async def is_login(response: Response, request: Request):
    user = check_auth_user(response,request)
    return get_current_user(user['email'])


# -----------------------------------авторизация--------------------------


@app.post("/api/v1/signin")
async def login(user_sign_in: models.userSignin, response: Response):
    if not authenticate_user(user_sign_in):
        raise HTTPException(status_code=401)
    users_collection = db.users
    access_token_expires = timedelta(minutes=Config.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": str(users_collection.find_one({'email': user_sign_in.email})['_id'])},
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
    try:
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    code = str(random.randint(1000, 9999))
    new_userbd = {
        '_id': l+1,
        'first_name': new_user.first_name,
        'last_name': new_user.last_name,
        'email': new_user.email,
        'password': Config.SECRET_KEY_PASSWORD + hasp_password,
        'is_active': False,
        'code': code,
        'doe_pwd': ""
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
    await send_mes(email, Config.EMAIL_TEXT_PWD + code)
    return get_current_user(email)


@app.post("/api/v1/change_password")
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


@app.get("/api/v1/checkcode_activ/{code}")
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


# --------------------------------------------------категории--------------------------

@app.get("/api/v1/categories")
async def categories(response: Response):
    users_collection = db.categories_items
    item_collection = db.items
    cat = users_collection.distinct('name')
    list_of_categories = []
    for p_main in cat:
        id_name = users_collection.find_one({'name': p_main})['id_name']
        p_m = models.cat_json_main(id=id_name,
                                   kol=item_collection.find({"categories": id_name}).count()
                                   , name=p_main, image_url=users_collection.find_one({'name': p_main})['image_url'],
                                   subcategories=[])
        for p_subtype in users_collection.distinct('subtype', {'name': p_main}):
            p_s = models.cat_json(id=str(users_collection.find_one({'name': p_main, 'subtype': p_subtype})['id_subtype'])
                                  , name=p_subtype, subcategories=[])
            for p_last in users_collection.distinct('lasttype', {'name': p_main, 'subtype': p_subtype}):
                p_s.subcategories.append(models.cat_json(
                    id=str(users_collection.find_one({'name': p_main, 'subtype': p_subtype, 'lasttype': p_last})['id_lasttype'])
                    , name=p_last, subcategories=[]))
            p_m.subcategories.append(p_s)
        list_of_categories.append(p_m)
    response.status_code = status.HTTP_200_OK
    return list_of_categories

@app.post("/api/v1/categories")
async def add_categories(new_cat: models.new_categories, response: Response):
    users_collection = db.categories_items
    if users_collection.find_one({"name": new_cat.main, "subtype": new_cat.subtype, "lasttype": new_cat.lasttype}):
        raise HTTPException(status_code=403)
    try:
        l=users_collection.distinct('_id')[-1]
    except:
        l=0
    c_c= users_collection.distinct("name")
    if new_cat.main in c_c:
        m_i= users_collection.find_one({"name":new_cat.main})['id_name']
    else:
        m_i =str(len(c_c)+1)
    c_c = users_collection.distinct("subtype",{"name":new_cat.main})
    if new_cat.subtype in c_c:
        s_i = users_collection.find_one({"name": new_cat.main,"subtype":new_cat.subtype})['id_subtype']
    else:
        s_i = str(m_i) + str(len(c_c) + 1)
    l_i=len(users_collection.distinct("name",{"name":new_cat.main,"subtype":new_cat.subtype}))
    new_categories = {
        '_id': l+1,
        'id_name':m_i,
        'name': new_cat.main,
        'image_url': new_cat.image_url,
        'id_subtype':str(s_i),
        'subtype': new_cat.subtype,
        'id_lasttype':str(s_i) + str(l_i +1),
        'lasttype': new_cat.lasttype
    }
    users_collection.insert_one(new_categories)
    response.status_code = status.HTTP_201_CREATED
    return new_cat


@app.patch("/api/v1/categories")
async def edit_categories(id: int, edit_cat: models.patch_categories, response: Response):
    users_collection = db.categories_items
    current_cat = users_collection.find_one({"_id": id})

    if not current_cat:
        raise HTTPException(status_code=403)
    users_collection.update_one({'_id': id}, {'$set': {'subtype': edit_cat.subtype, 'name': edit_cat.name,
                                                       'lasttype': edit_cat.lasttype}})
    users_collection.update({'name': current_cat['name']}, {"$set": {'image_url': edit_cat.image_url}},
                            multi=True)
    response.status_code = status.HTTP_200_OK
    return models.patch_categories(id=str(id), name=edit_cat.name, subtype=edit_cat.subtype, lasttype=edit_cat.lasttype,
                                   image_url=edit_cat.image_url)


# -------------------------------ТОВАРЫ----------------------------------
@app.get("/api/v1/items_cat/{id}")
async def items_cat(id:str,response: Response):
    list_of_items=[]
    items_collection = db.items
    items = items_collection.find({"categories":id}).sort("name",1)
    for post in items:
        list_of_items.append(models.items(id=post['_id'],
                                          name=post['name'],
                                            description=post['description'],
                                            size=post['size'],
                                            color=items['color'],
                                            image=post['image'],
                                            price=post['price'],
                                            discount=post['discount'],
                                            hit_sales=post['hit_sales'],
                                            special_offer=post['special_offer'],
                                            categories=post['categories']))

    print(list_of_items)
    return list_of_items

@app.post("/api/v1/items_ind")
async def items_ind(index:list,response: Response):
    items_collection = db.items
    list_of_items = []
    for post in index:
        items= items_collection.find_one({"_id":int(post)})
        if items:
            list_of_items.append(models.items(id=items['_id'],
                                          name=items['name'],
                                            description=items['description'],
                                            size=items['size'],
                                            color=items['color'],
                                            image=items['image'],
                                            price=items['price'],
                                            discount=items['discount'],
                                            hit_sales=items['hit_sales'],
                                            special_offer=items['special_offer'],
                                            categories=items['categories']))
    return list_of_items

@app.post("/api/v1/items")
async def add_items(new_item: models.add_items, response: Response):
    users_collection = db.items
    try:
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    cat_collection = db.categories_items
    cur_cat = cat_collection.find_one({"name":new_item.categories[0],"subtype":new_item.categories[1],"lasttype":new_item.categories[2]})
    if not cur_cat:
        raise HTTPException(status_code=403)

    new_item = {
        '_id': l+1,
        "name": new_item.name,
        "description": new_item.description,
        "size":new_item.size,
        "color":new_item.color,
        "image": new_item.image,
        "price": new_item.price,
        "discount": new_item.discount,
        "hit_sales": new_item.hit_sales,
        "special_offer": new_item.special_offer,
        "categories": [str(cur_cat['id_name']),str(cur_cat['id_subtype']),str(cur_cat['id_lasttype'])]
    }
    users_collection.insert_one(new_item)
    response.status_code = status.HTTP_200_OK
    return new_item


@app.get("/api/v1/items")
async def get_items(response: Response):
    users_collection = db.items
    all_items = users_collection.find()
    a_i = []
    for post in all_items:
        a_i.append(models.items(id=post['_id'],
                              name=post['name'],
                                description=post['description'],
                                size=post['size'],
                                color=post['color'],
                                image=post['image'],
                                price=post['price'],
                                discount=post['discount'],
                                hit_sales=post['hit_sales'],
                                special_offer=post['special_offer'],
                                categories=post['categories']))
    response.status_code = status.HTTP_200_OK
    return a_i

@app.get("/api/v1/items/{id}")
async def get_items(id:int,response: Response):
    users_collection = db.items
    items = users_collection.find_one({"_id":id})

    if not items:
        raise HTTPException(status_code=403)
    response.status_code = status.HTTP_200_OK
    return models.items(id=items['_id'],name=items['name'],description=items['description'],size=items['size'],
                        color=items['color'],image=items['image'],price= items['price'],discount= items['discount'],
                        hit_sales= items['hit_sales'],special_offer= items['special_offer'],
                        categories= items['categories'])



@app.patch("/api/v1/items")
async def patch_items(patch_item: models.patch_items, response: Response):
    users_collection = db.items
    items = users_collection.find_one({"_id":patch_item.id})
    if not items:
        raise HTTPException(status_code=403)
    cat_collection=db.categories_items
    cur_cat = cat_collection.find_one(
        {"name": patch_item.categories[0], "subtype": patch_item.categories[1], "lasttype": patch_item.categories[2]})
    if not cur_cat:
        raise HTTPException(status_code=403)
    current_item = users_collection.update_one({'_id': patch_item.id},
                                               {"$set":{ "name": patch_item.name,
                                                        "description": patch_item.description,
                                                        "size":patch_item.size,
                                                        "color":patch_item.color,
                                                        "image": patch_item.image,
                                                        "price": patch_item.price,
                                                        "discount": patch_item.discount,
                                                        "hit_sales": patch_item.hit_sales,
                                                        "special_offer": patch_item.special_offer,
                                                        "categories": [str(cur_cat['id_name']),str(cur_cat['id_subtype']),
                                                                      str(cur_cat['id_lasttype'])]}})
    if not current_item:
        raise HTTPException(status_code=403)

    return models.items(id=patch_item.id,name=patch_item.name,description=patch_item.description,size=patch_item.size,
                        color=patch_item.color,image=patch_item.image,price= patch_item.price,discount= patch_item.discount,
                        hit_sales= patch_item.hit_sales,special_offer= patch_item.special_offer,
                        categories= [str(cur_cat['id_name']),str(cur_cat['id_subtype']),str(cur_cat['id_lasttype'])])


@app.delete("/api/v1/items")
async def delete_items(id: str):
    users_collection = db.items
    users_collection.remove({"_id": id})
    return HTTPException(status_code=200)


# ------image
"""@app.post("/api/v1/uploadfile")
async def create_upload_file(file: UploadFile = File(...)):
    '''try:

        with open(file.filename, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    finally:
        file.file.close()
    '''
    print(os.getcwd())
    return {"filename": file.filename}
"""


# --------------------------------------ПОИСК ТОВАРА----------------
@app.get("/api/v1/search")
async def search(poisk: str, response: Response):
    users_collection = db.categories_items
    list_of_index = []
    list_of_cat = users_collection.find({"name": poisk}).distinct("id_name")
    if list_of_cat:
        for post in list_of_cat:
            list_of_index.append(post)
    else:
        list_of_cat = users_collection.find({"subtype": poisk}).distinct("id_subtype")
        if list_of_cat:
            for post in list_of_cat:
                    list_of_index.append(post)
        else:
            list_of_cat = users_collection.find({"lasttype": poisk}).distinct("id_subtype")
            if list_of_cat:
                for post in list_of_cat:
                    list_of_index.append(post)
    list_of_items = []
    users_collection = db.items
    for post in list_of_index:
        current_items = users_collection.find({"categories":str(post)})
        for p in current_items:
            list_of_items.append(models.items(id=p['_id'], name=p['name'], description=p['description'],size=p['size'],
                                              color=p['color'],image=p['image'], price=p['price'], discount=p['discount'],
                                              hit_sales=p['hit_sales'], special_offer=p['special_offer'],
                                              categories=p['categories']))
    if not list_of_items:
        items = users_collection.find({"name": {'$regex': poisk}})
        for p in items:
            list_of_items.append(models.items(id=p['_id'], name=p['name'], description=p['description'],size=p['size'],
                                              color=p['color'],image=p['image'], price=p['price'], discount=p['discount'],
                                              hit_sales=p['hit_sales'], special_offer=p['special_offer'],
                                              categories=p['categories']))
    return list_of_items

#------------------------------------------корзина
@app.post("/api/v1/cart/addProduct")
async def add_Product_in_shopping_cart(add_product: models.product_in_sc,response: Response, request: Request ):
    user = check_auth_user(response,request)
    items_collection =db.items
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    items = items_collection.find_one({"_id":add_product.id})
    if not items:
        raise HTTPException(status_code=403)
    try:
        l = shopping_cart_collection.distinct('_id')[-1]
    except:
        l = 0
    if not shopping_cart:
        list_of_items = []
        list_of_items.append({'id':add_product.id,'size':add_product.size,'kol':add_product.kol,'image':items['image'],'price':items['price'],'discount':items['discount']})
        print(list_of_items)
        new_shopping_cart={
            '_id':l+1,
            'id_users':user['_id'],
            'items': list_of_items
        }
        shopping_cart_collection.insert_one(new_shopping_cart)
        return models.shopping_cart(id=l+1,
                                    id_user=user['_id'],
                                    items=list_of_items)
    else:
        list_of_items = shopping_cart['items']
        for post in list_of_items:
            if post['id']==add_product.id and post['size'] == add_product.size:
                raise HTTPException(status_code=409)
        shopping_cart_collection.update_one({"_id":shopping_cart['_id']},
                                            {"$push":{"items":{'id':add_product.id,
                                                               'size':add_product.size,
                                                               'kol':add_product.kol,
                                                               'image':items['image'],
                                                               'price':items['price'],
                                                               'discount':items['discount']}}})
    return models.shopping_cart(id=shopping_cart['_id'],
                                id_user=user['_id'],
                                items =shopping_cart_collection.find_one({"_id":shopping_cart['_id']})['items'] )


@app.get("/api/v1/cart/shopping_cart")
async def get_shopping_cart(response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    if not shopping_cart:
        return []
    return models.shopping_cart(id=shopping_cart['_id'],
                                id_user=user['_id'],
                                items=shopping_cart_collection.find_one({"_id": shopping_cart['_id']})['items'])

@app.delete("/api/v1/cart/delproduct")
async def delete_Product_in_shopping_cart(del_items:models.del_product_in_sc,response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart_collection.update_one({"id_users":int(user['_id'])},
                                            {"$pull": {"items":{'id':del_items.id,
                                                               'size':del_items.size}}})
@app.get("/api/v1/test")
async def test():
    users_collection = db.Items
    temp = users_collection.find_one({"zxc": "asd"})
    return {"as": temp["zxc"]}
