import hashlib
import random
import uuid
import shutil
import os
from typing import Optional
import smtplib
from jose import JWTError, jwt
from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi import Response
import json
from pymongo import MongoClient
from datetime import datetime, timedelta
from email.mime.text import MIMEText
from email.header import Header
from starlette import status
import models
from fastapi.middleware.cors import CORSMiddleware
from config import Config
from starlette.requests import Request

app = FastAPI()
list_user_favorites_items = []

client = MongoClient('localhost', 27017, username='root', password='example')

#client = MongoClient('mongo', 27017, username='root', password='example')
db = client.zarinshop
'''app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
'''

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
        raise HTTPException(status_code=403)
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

        payload = jwt.decode(token, Config.SECRET_KEY, algorithms=[Config.ALGORITHM])
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


'''def check_auth_user(response: Response, request: Request):
    try:
        if not request.headers['authorization']:
            raise HTTPException(status_code=401)
        user = get_current_session_user(request.headers['authorization'][7:])
        return user
    except:
        raise HTTPException(status_code=401)
'''
def check_auth_user(response: Response, request: Request):
    if (not request.cookies) or ('session_token' not in request.cookies):
        raise HTTPException(status_code=401)
    try:
        user = get_current_session_user(request.cookies.get('session_token'))
        return user
    except JWTError:
        raise HTTPException(status_code=401)




@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    print(str(request.url).replace(str(request.base_url), ""))
    if (str(request.url).replace(str(request.base_url), "") == "docs"):
        print("admin url")
    if ((request.method == "POST") or (request.method == "DELETE") or
        (request.method == "PATCH")) and str(request.url).replace(str(request.base_url), "") in Config.ADMIN_URL:
        print("admin url")
    response = await call_next(request)
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


@app.get("/api/v1/is_admin")
async def is_admin(response: Response, request: Request):
    user = check_auth_user(response, request)
    if user['_id'] in Config.ADMIN_LIST:
        return True
    else:
        return False


@app.get("/api/v1/is_login")
async def is_login(response: Response, request: Request):
    user = check_auth_user(response, request)
    return get_current_user(user['email'])


# -----------------------------------авторизация--------------------------


@app.post("/api/v1/signin")
async def login(user_sign_in: models.userSignin, response: Response):
    if not authenticate_user(user_sign_in):
        raise HTTPException(status_code=401)
    users_collection = db.users
    access_token_expires = timedelta(minutes=Config.ACCESS_TOKEN_EXPIRE_MINUTES)
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


@app.post("/api/v1/signup")
async def registration_user(new_user: models.userSignup, response: Response):
    users_collection = db.users
    user = users_collection.find_one({"email": new_user.email})
    if user:
        if user['is_active']:
            raise HTTPException(status_code=403)
        users_collection.remove({"_id": user['_id']})
    hasp_password = hashlib.pbkdf2_hmac('sha256', new_user.password.encode('utf-8'), Config.SECRET_KEY_PASSWORD, 100000)
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


@app.get("/api/v1/checkcode_activ")
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


def get_items_model(post):
    link_collection = db.link_color
    favorite_items = False
    if post['_id'] in list_user_favorites_items:
        favorite_items = True
    return models.items(id=post['_id'],
                        name=post['name'],
                        description=post['description'],
                        size_kol=post['size_kol'],
                        color=post['color'],
                        images=post['images'],
                        name_images=post['name_images'],
                        price=post['price'],
                        discount=post['discount'],
                        hit_sales=post['hit_sales'],
                        special_offer=post['special_offer'],
                        categories=post['categories'],
                        link_color=link_collection.find_one({"_id": post['link_color']})[
                            'color_link'],
                        favorites=favorite_items,
                        categories_value=post['categories_value'])


@app.get("/api/v1/hit_sales")
async def get_hit_sales(response: Response):
    items_collectoin = db.items
    list_items = []
    items = items_collectoin.find({"hit_sales": True})
    list_index = []
    for i in range(items.count()):
        list_index.append(i)
    if len(list_index) > 8:
        list_index = random.sample(list_index,8)
    for post in list_index:
        list_items.append(get_items_model(items[post]))
    return list_items

@app.get("/api/v1/special_offer")
async def get_special_offer(response: Response):
    items_collectoin = db.items
    list_items = []
    items = items_collectoin.find({"special_offer": True})
    list_index = []
    for i in range(items.count()):
        list_index.append(i)
    if len(list_index) > 8:
        list_index = random.sample(list_index,8)
    for post in list_index:
        list_items.append(get_items_model(items[post]))
    return list_items


# --------------------------------------------------категории--------------------------

@app.get("/api/v1/categories")
async def categories(response: Response):
    '''global list_user_favorites_items
    try:
        if request.headers['authorization']:
            user = get_current_session_user(request.headers['authorization'][7:])
            list_favorites = db.favourites.find_one({"id_user": user['_id']})
            if list_favorites:
                list_user_favorites_items = list_favorites['list_favourites']
    except:
        print(list_user_favorites_items)
    print(list_user_favorites_items)'''
    users_collection = db.categories_items
    item_collection = db.items
    cat = users_collection.distinct('name')
    list_of_categories = []
    for p_main in cat:
        id_name = users_collection.find_one({'name': p_main})['id_name']
        if item_collection.find({"categories": id_name}).count() != 0:
            p_m = models.cat_json_main(id=id_name,
                                       kol=item_collection.find({"categories": id_name}).count(), name=p_main,
                                       subcategories=[])
            for p_subtype in users_collection.distinct('subtype', {'name': p_main}):
                if p_subtype:
                    p_s = models.cat_json(
                        id=str(users_collection.find_one({'name': p_main, 'subtype': p_subtype})['id_subtype']),
                        name=p_subtype, subcategories=[])
                    for p_last in users_collection.distinct('lasttype', {'name': p_main, 'subtype': p_subtype}):
                        if p_last:
                            p_s.subcategories.append(models.cat_json(
                                id=str(users_collection.find_one(
                                    {'name': p_main, 'subtype': p_subtype, 'lasttype': p_last})
                                       ['id_lasttype']), name=p_last, subcategories=[]))
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
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    c_c = users_collection.distinct("name")
    if new_cat.main in c_c:
        main_index = users_collection.find_one({"name": new_cat.main})['id_name']
    else:
        main_index = str(len(c_c) + 1)
    c_c = users_collection.distinct("subtype", {"name": new_cat.main})
    if new_cat.subtype in c_c:
        subtype_index = users_collection.find_one({"name": new_cat.main, "subtype": new_cat.subtype})['id_subtype']
    else:
        subtype_index = str(main_index) + str(len(c_c) + 1)
    last_index = len(users_collection.distinct("name", {"name": new_cat.main, "subtype": new_cat.subtype}))
    new_categories = {
        '_id': l + 1,
        'id_name': main_index,
        'name': new_cat.main,
        'id_subtype': str(subtype_index),
        'subtype': new_cat.subtype,
        'id_lasttype': str(subtype_index) + str(last_index + 1),
        'lasttype': new_cat.lasttype
    }
    users_collection.insert_one(new_categories)
    response.status_code = status.HTTP_201_CREATED
    return new_categories


@app.patch("/api/v1/categories")
async def edit_categories(edit_cat: models.patch_categories, response: Response):
    categories_collection = db.categories_items
    items_collection = db.items
    current_cat = categories_collection.find_one({"_id": edit_cat.id})
    if not current_cat:
        raise HTTPException(status_code=403)
    print(current_cat)
    items = items_collection.find({"categories": current_cat['id_lasttype']})
    list_categories_value = []
    list_categories_value.append(edit_cat.main)
    if edit_cat.subtype:
        list_categories_value.append(edit_cat.subtype)
        if edit_cat.lasttype:
            list_categories_value.append(edit_cat.lasttype)
    for post in items:
        items_collection.update({"_id": post['_id']}, {'$set': {'categories_value': list_categories_value}})
    categories_collection.update_one({'_id': edit_cat.id}, {'$set': {'subtype': edit_cat.subtype, 'name': edit_cat.main,
                                                                     'lasttype': edit_cat.lasttype}})
    response.status_code = status.HTTP_200_OK
    return models.patch_categories(id=str(edit_cat.id), name=edit_cat.main, subtype=edit_cat.subtype,
                                   lasttype=edit_cat.lasttype)


@app.get("/api/v1/list_categories")
async def list_categories():
    cat_collection = db.categories_items
    list_categories = cat_collection.find();
    string_list_categories = []

    for post in list_categories:
        value = []
        text = post['name']
        value.append(post['name'])
        if post['subtype']:
            text = text + " - " + post['subtype']
            value.append(post['subtype'])
        if post['lasttype']:
            text = text + " - " + post['lasttype']
            value.append(post['lasttype'])
        new_cat = {
            "id": post['_id'],
            "text": text,
            "value": value
        }
        string_list_categories.append(new_cat)
    return string_list_categories



def delete_file(del_file):
    try:
        with open('/app/images/' + del_file, "wb") as buffer:
            os.remove(buffer.name)
    finally:
        return
@app.delete("/api/v1/categories")
async def delete_categories(delete_id: int):
    categories_collection = db.categories_items
    items_collectoin = db.items
    delete_categories = categories_collection.find_one({"_id": delete_id})
    if not delete_categories:
        raise HTTPException(status_code=409)
    items_list = items_collectoin.find({"categories": delete_categories['id_lasttype']})
    for post in items_list:
        for file_name in post['name_images']:
            delete_file(file_name)
    items_collectoin.remove({"categories": delete_categories['id_lasttype']})
    categories_collection.remove({"_id": delete_id})
    return


# ------------------------------ITEMS----------------------------------
# Add
@app.get("/api/v1/items_cat/{id}")
async def items_cat(id: str, response: Response):
    list_items = []
    items_collection = db.items
    items = items_collection.find({"categories": id}).sort("name", 1)
    for post in items:
        list_items.append(get_items_model(post))
    return list_items

@app.post("/api/v1/items")
async def add_items(new_item: models.add_items, response: Response):
    users_collection = db.items
    link_color_collectoin = db.link_color
    try:
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    try:
        id_lc = link_color_collectoin.distinct('_id')[-1]
    except:
        id_lc = 0
    cat_collection = db.categories_items
    for i in range(3 - len(new_item.categories)):
        new_item.categories.append("")
    cur_cat = cat_collection.find_one(
        {"name": new_item.categories[0], "subtype": new_item.categories[1], "lasttype": new_item.categories[2]})
    if not cur_cat:
        raise HTTPException(status_code=403)
    if new_item.link_color:
        currnet_link_color = link_color_collectoin.find_one(
            {"color_link": {"$elemMatch": {"id": new_item.link_color[0]}}})
        link_color_collectoin.update_one({"_id": currnet_link_color['_id']},
                                         {"$push": {"color_link": {"id": l + 1, "color": new_item.color}}})
    else:
        new_link_color = {
            "_id": id_lc + 1,
            "color_link": [{
                "id": l + 1,
                "color": new_item.color
            }]}
        link_color_collectoin.insert_one(new_link_color)
    list_categories_value = []
    list_categories_value.append(cur_cat['name'])
    if cur_cat['subtype']:
        list_categories_value.append(cur_cat['subtype'])
        if cur_cat['lasttype']:
            list_categories_value.append(cur_cat['lasttype'])
    discount = None
    if new_item.discount > 0:
            discount = new_item.discount
    new_i = {
        '_id': l + 1,
        "name": new_item.name,
        "description": new_item.description,
        "size_kol": new_item.size_kol,
        "color": new_item.color,
        "images": new_item.images,
        "price": new_item.price,
        "discount": discount,
        "hit_sales": new_item.hit_sales,
        "special_offer": new_item.special_offer,
        "categories": [str(cur_cat['id_name']), str(cur_cat['id_subtype']), str(cur_cat['id_lasttype'])],
        "link_color": link_color_collectoin.find_one({"color_link": {"$elemMatch": {"id": l + 1}}})['_id'],
        "categories_value": list_categories_value,
        "name_images": new_item.name_images
    }
    users_collection.insert_one(new_i)
    response.status_code = status.HTTP_200_OK
    return new_i


@app.get("/api/v1/items")
async def get_items(response: Response):
    users_collection = db.items
    all_items = users_collection.find()
    list_items = []
    for post in all_items:
        list_items.append(get_items_model(post))
    response.status_code = status.HTTP_200_OK
    return list_items


@app.post("/api/v1/items_ind")
async def items_ind(index: list, response: Response):
    items_collection = db.items
    list_items = []
    for post in index:
        items = items_collection.find_one({"_id": int(post)})
        if items:
            list_items.append(get_items_model(items))
    return list_items


# edit items
@app.patch("/api/v1/items")
async def patch_items(patch_item: models.patch_items, response: Response):
    users_collection = db.items
    link_collection = db.link_color
    items = users_collection.find_one({"_id": patch_item.id})
    if not items:
        raise HTTPException(status_code=403)
    cat_collection = db.categories_items
    for i in range(3 - len(patch_item.categories)):
        patch_item.categories.append("")
    cur_cat = cat_collection.find_one(
        {"name": patch_item.categories[0], "subtype": patch_item.categories[1], "lasttype": patch_item.categories[2]})
    if not cur_cat:
        raise HTTPException(status_code=403)
    list_categories_value = []
    list_categories_value.append(cur_cat['name'])
    if cur_cat['subtype']:
        list_categories_value.append(cur_cat['subtype'])
        if cur_cat['lasttype']:
            list_categories_value.append(cur_cat['lasttype'])
    id_link_color = link_collection.find_one({"color_link": {"$elemMatch": {"id": patch_item.id}}})['_id']
    discount = None
    if patch_item.discount > 0:
        discount = patch_item.discount
    current_item = users_collection.update_one({'_id': patch_item.id},
                                               {"$set": {"name": patch_item.name,
                                                         "description": patch_item.description,
                                                         "size_kol": patch_item.size_kol,
                                                         "color": patch_item.color,
                                                         "images": patch_item.images,
                                                         "price": patch_item.price,
                                                         "discount": discount,
                                                         "hit_sales": patch_item.hit_sales,
                                                         "special_offer": patch_item.special_offer,
                                                         "categories": [str(cur_cat['id_name']),
                                                                        str(cur_cat['id_subtype']),
                                                                        str(cur_cat['id_lasttype'])],
                                                         "categories_value": list_categories_value,
                                                         "link_color": id_link_color,
                                                         "name_images": patch_item.name_images}})
    if not current_item:
        raise HTTPException(status_code=403)
    return models.items(id=patch_item.id, name=patch_item.name, description=patch_item.description,
                        size_kol=patch_item.size_kol,
                        color=patch_item.color, images=patch_item.images, price=patch_item.price,
                        discount=patch_item.discount,
                        hit_sales=patch_item.hit_sales, special_offer=patch_item.special_offer,
                        categories=[str(cur_cat['id_name']), str(cur_cat['id_subtype']), str(cur_cat['id_lasttype'])],
                        link_color=link_collection.find_one({"_id": id_link_color})['color_link'])


@app.delete("/api/v1/items")
async def delete_items(delete_id: int):
    users_collection = db.items
    link_collection = db.link_color
    del_items = users_collection.find_one({"_id": delete_id})
    if not del_items:
        return HTTPException(status_code=200)
    link_collection.update_one({"_id": del_items['link_color']},
                               {"$pull": {"color_link": {
                                   "id": delete_id,
                                   "color": del_items['color']}}})
    users_collection.remove({"_id": delete_id})
    if not link_collection.find_one({"_id": del_items['link_color']})['color_link']:
        link_collection.remove({"_id": del_items['link_color']})
    user_shopping_cart = db.shopping_cart
    for i in range(len(user_shopping_cart.distinct('_id'))):
        user_shopping_cart.update({"_id": i + 1}, {"$pull": {"items": {'id': delete_id}}})
    return HTTPException(status_code=200)


@app.get("/api/v1/items/{id}")
async def get_items(id: int, response: Response):
    users_collection = db.items
    items = users_collection.find_one({"_id": id})
    link_collection = db.link_color
    if not items:
        raise HTTPException(status_code=403)
    response.status_code = status.HTTP_200_OK
    return get_items_model(items)


# ------image

@app.post("/api/v1/uploadfile/")
async def create_upload_file(file: UploadFile = File(...)):
    try:
        with open('/app/images/' + file.filename, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    finally:
        file.file.close()
    return {"file_name": file.filename, "file_url": "https://mirllex.site/img/" + file.filename}


@app.post("/api/v1/del_file/")
async def create_upload_file(del_file: models.del_file):
    try:
        with open('/app/images/' + del_file.name, "wb") as buffer:
            os.remove(buffer.name)
    finally:
        return
    return


@app.get("/api/v1/search")
async def search(poisk: str, response: Response):
    items_collection = db.items
    list_of_items = []
    list_poisk_items = items_collection.find()
    for post in list_poisk_items:
        if poisk.lower() in post['name'].lower():
            list_of_items.append(get_items_model(post))
    return list_of_items


@app.post("/api/v1/cart/addProduct")
async def add_Product_in_shopping_cart(add_product: models.product_in_sc, response: Response, request: Request):
    user = check_auth_user(response, request)
    items_collection = db.items
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    items = items_collection.find_one({"_id": add_product.id})
    if not items:
        raise HTTPException(status_code=403)
    try:
        l = shopping_cart_collection.distinct('_id')[-1]
    except:
        l = 0
    if not shopping_cart:
        list_of_items = []
        list_of_items.append(
            {'id': add_product.id, 'name': items['name'], 'size': add_product.size, 'kol': add_product.kol,
             'images': items['images'], 'color': items['color'], 'price': items['price'],
             'discount': items['discount']})
        new_shopping_cart = {
            '_id': l + 1,
            'id_users': user['_id'],
            'items': list_of_items
        }
        shopping_cart_collection.insert_one(new_shopping_cart)
        return models.shopping_cart(id=l + 1,
                                    id_user=user['_id'],
                                    items=list_of_items)
    else:
        list_of_items = shopping_cart['items']
        for post in list_of_items:
            if post['id'] == add_product.id and post['size'] == add_product.size:
                shopping_cart_collection.update_one(
                    {"id_users": int(user['_id']), "items.id": add_product.id, "items.size": add_product.size},
                    {"$set": {"items.$.kol": add_product.kol + post['kol']}})
                return models.shopping_cart(id=shopping_cart['_id'],
                                            id_user=user['_id'],
                                            items=shopping_cart_collection.find_one({"_id": shopping_cart['_id']})[
                                                'items'])
        shopping_cart_collection.update_one({"_id": shopping_cart['_id']},
                                            {"$push": {"items": {'id': add_product.id,
                                                                 'name': items['name'],
                                                                 'size': add_product.size,
                                                                 'kol': add_product.kol,
                                                                 'images': items['images'],
                                                                 'color': items['color'],
                                                                 'price': items['price'],
                                                                 'discount': items['discount']}}})
    return models.shopping_cart(id=shopping_cart['_id'],
                                id_user=user['_id'],
                                items=shopping_cart_collection.find_one({"_id": shopping_cart['_id']})['items'])


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
async def delete_Product_in_shopping_cart(del_items: models.del_product_in_sc, response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart_collection.update_one({"id_users": int(user['_id'])},
                                        {"$pull": {"items": {'id': del_items.id,
                                                             'size': del_items.size}}})




@app.get("/api/v1/user_order")
async def user_order(response: Response, request: Request):
    user = check_auth_user(response, request)
    order_collection = db.order_history
    all_user_order = order_collection.find({"id_user": user['_id']})
    list_user_order = []
    for post in all_user_order:
        list_user_order.append(models.user_order(date=post['date'],
                                                 order=post['items']))
    return list_user_order


@app.get("/api/v1/get_favourites")
async def get_favourites(response: Response, request: Request):
    user = check_auth_user(response, request)
    favourites_coll = db.favourites
    items_coll = db.items
    list_favourites = []
    link_collection = db.link_color
    favourites = favourites_coll.find_one({"id_user": user['_id']})
    if favourites:
        for index in favourites['list_favourites']:
            items = items_coll.find_one({"_id": index})
            if items:
                list_favourites.append(
                    models.items(id=items['_id'], name=items['name'], description=items['description'],
                                 size_kol=items['size_kol'], color=items['color'],
                                 images=items['images'], price=items['price'], discount=items['discount'],
                                 hit_sales=items['hit_sales'], special_offer=items['special_offer'],
                                 categories=items['categories'],
                                 link_color=link_collection.find_one({"_id": items['link_color']})[
                                     'color_link'], favorites=True))

    return list_favourites


@app.post("/api/v1/add_favourites")
async def add_favourites(add_fav: models.index_favourites, response: Response, request: Request):
    user = check_auth_user(response, request)
    if not db.items.find_one({"_id": add_fav.id}):
        raise HTTPException(status_code=404)
    favourites_coll = db.favourites
    favourites_list = favourites_coll.find_one({"id_user": user['_id']})

    if not favourites_list:
        new_fav = {
            "id_user": user['_id'],
            "list_favourites": [add_fav.id]
        }
        favourites_coll.insert_one(new_fav)
    else:
        if add_fav.id not in favourites_list['list_favourites']:
            favourites_coll.update({"id_user": user['_id']},
                                   {"$push": {"list_favourites": add_fav.id}})
    return favourites_coll.find_one({"id_user": user['_id']})['list_favourites']


@app.post("/api/v1/del_favourites")
async def del_favourites(del_fav: models.index_favourites, response: Response, request: Request):
    user = check_auth_user(response, request)
    if not db.items.find_one({"_id": del_fav.id}):
        raise HTTPException(status_code=404)
    favourites_coll = db.favourites
    favourites = favourites_coll.find_one({"id_user": user['_id']})
    if not favourites:
        raise HTTPException(status_code=404)
    favourites_coll.update({"id_user": user['_id']},
                           {"$pull": {"list_favourites": del_fav.id}})
    return favourites_coll.find_one({"id_user": user['_id']})['list_favourites']

#-----------------ORDER-------------
@app.post("/api/v1/make_an_order")
async def make_an_order(number_order:models.Order_registration,response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    if not shopping_cart:
        raise HTTPException(status_code=404)
    if not shopping_cart['items']:
        raise HTTPException(status_code=404)
    order_collection = db.order_history
    if order_collection.find_one({"order_number":number_order.number_order,"id_user":user['_id'],"state":"Ожидает оплату"}):
        raise HTTPException(status_code=409)
    try:
        l = order_collection.distinct('_id')[-1]
    except:
        l = 0
    new_order={
        "_id":l+1,
        "order_number":number_order.number_order,
        "id_user":user['_id'],
        "items":shopping_cart['items'],
        "state":"Ожидает оплату",
        "date": datetime.now().strftime("%d-%m-%Y %H:%M")
    }
    shopping_cart_collection.remove({"id_users":user['_id']})
    order_collection.insert_one(new_order)
    list_of_order = order_collection.find({"id_user":user['_id']})
    if list_of_order.count() > 3:
        order_collection.remove({"_id":list_of_order[0]['_id']})
    return new_order

@app.post("/api/v1/order_confirmation")
async def order_confirmation(number_order:models.Order_registration,response: Response, request: Request):
    user = check_auth_user(response, request)
    order_collection = db.order_history
    currnet_order = order_collection.find_one({"order_number":number_order.number_order,"id_user":user['_id'],"state":"Ожидает оплату"})
    if not currnet_order:
        raise HTTPException(status_code=404)
    if currnet_order['id_user'] != user['_id']:
        raise HTTPException(status_code=409)
    order_collection.update({"_id":currnet_order["_id"]},{"$set":{"state":"Оплачено"}})
    return order_collection.find_one({"order_number":number_order.number_order})

