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
from email.header    import Header
from starlette import status
import models
from fastapi.middleware.cors import CORSMiddleware
from config import Config, Click, Language
from starlette.requests import Request

app = FastAPI()
list_user_favorites_items = []

client = MongoClient('mongo', 27017, username='root', password='example')
db = client.zarinshop
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



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
    msg =MIMEText(text, 'plain', 'utf-8')
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

def check_auth_user(response: Response, request: Request):
    try:
        if not request.headers['authorization']:
            raise HTTPException(status_code=401)
        user = get_current_session_user(request.headers['authorization'][7:])
        return user
    except:
        raise HTTPException(status_code=401)

 
@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    #print(str(request.url).replace(str(request.base_url),""))
    response = await call_next(request)
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response


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
    ##response.headers["Authorization"] ="Bearer " + access_token
    response.set_cookie(key="session_token", value=access_token)
    ##response.set_cookie(key="session_token", value=f"Bearer {access_token})
    user =get_current_user(user_sign_in.email)
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
        users_collection.remove({"_id":user['_id']}) 
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
    if not current_user['is_active']:
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



@app.get("/api/v1/checkcode_activ")
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

def get_items_model(post,language):
    link_collection = db.link_color

    favorite_items = False
    if post['_id'] in list_user_favorites_items:
        favorite_items = True
    if language == "ru":
        return models.items(id=post['_id'],
                            name=post['name_ru'],
                            description=post['description_ru'],
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
    elif language == "uz":
        return models.items(id=post['_id'],
                            name=post['name_uz'],
                            description=post['description_uz'],
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
    else:
        raise HTTPException(status_code=404)

@app.get("/api/v1/{language}/hit_sales")
async def get_hit_sales(response: Response,language:str):
    items_collectoin = db.items
    list_items = []
    items = items_collectoin.find({"hit_sales": True})
    list_index = []
    for i in range(items.count()):
        list_index.append(i)
    if len(list_index) > 8:
        list_index = random.sample(list_index,8)
    for post in list_index:
        list_items.append(get_items_model(items[post],language))
    return list_items

@app.get("/api/v1/{language}/special_offer")
async def get_special_offer(response: Response,language:str):
    items_collectoin = db.items
    list_items = []
    items = items_collectoin.find({"special_offer": True})
    list_index = []
    for i in range(items.count()):
        list_index.append(i)
    if len(list_index) > 8:
        list_index = random.sample(list_index,8)
    for post in list_index:
        list_items.append(get_items_model(items[post],language))
    return list_items
# --------------------------------------------------категории--------------------------

@app.get("/api/v1/{language}/categories")
async def categories(response: Response, language:str):
    users_collection = db.categories_items
    item_collection = db.items
    list_of_categories = []
    if language == "ru":
        cat = users_collection.distinct('name_ru')

        for p_main in cat:
            id_name = users_collection.find_one({'name_ru': p_main})['id_name']

            if item_collection.find({"categories": str(id_name)}).count() != 0:
                p_m = models.cat_json_main(id=id_name,
                                           kol=item_collection.find({"categories": id_name}).count(), name=p_main,
                                           subcategories=[])
                for p_subtype in users_collection.distinct('subtype_ru', {'name_ru': p_main}):
                    if p_subtype:
                        p_s = models.cat_json(
                            id=str(users_collection.find_one({'name_ru': p_main, 'subtype_ru': p_subtype})['id_subtype']),
                            name=p_subtype, subcategories=[])
                        for p_last in users_collection.distinct('lasttype_ru', {'name_ru': p_main, 'subtype_ru': p_subtype}):
                            if p_last:
                                p_s.subcategories.append(models.cat_json(
                                    id=str(users_collection.find_one(
                                        {'name_ru': p_main, 'subtype_ru': p_subtype, 'lasttype_ru': p_last})
                                           ['id_lasttype']), name=p_last, subcategories=[]))
                        p_m.subcategories.append(p_s)
                list_of_categories.append(p_m)
    elif language == "uz":
        cat = users_collection.distinct('name_uz')
        for p_main in cat:
            id_name = users_collection.find_one({'name_uz': p_main})['id_name']
            if item_collection.find({"categories": str(id_name)}).count() != 0:
                p_m = models.cat_json_main(id=id_name,
                                           kol=item_collection.find({"categories": id_name}).count(), name=p_main,
                                           subcategories=[])
                for p_subtype in users_collection.distinct('subtype_uz', {'name_uz': p_main}):
                    if p_subtype:
                        p_s = models.cat_json(
                            id=str(
                                users_collection.find_one({'name_uz': p_main, 'subtype_uz': p_subtype})['id_subtype']),
                            name=p_subtype, subcategories=[])
                        for p_last in users_collection.distinct('lasttype_uz',
                                                                {'name_uz': p_main, 'subtype_uz': p_subtype}):
                            if p_last:
                                p_s.subcategories.append(models.cat_json(
                                    id=str(users_collection.find_one(
                                        {'name_uz': p_main, 'subtype_uz': p_subtype, 'lasttype_uz': p_last})
                                           ['id_lasttype']), name=p_last, subcategories=[]))
                        p_m.subcategories.append(p_s)
                list_of_categories.append(p_m)
    else:
        raise HTTPException(status_code=404)
    response.status_code = status.HTTP_200_OK
    return list_of_categories

@app.post("/api/v1/categories")
async def add_categories(new_cat: models.new_categories, response: Response):
    users_collection = db.categories_items
    if users_collection.find_one({"name_ru": new_cat.main_ru, "subtype_ru": new_cat.subtype_ru, "lasttype_ru": new_cat.lasttype_ru}):
        raise HTTPException(status_code=403)
    if users_collection.find_one({"name_uz": new_cat.main_uz, "subtype_uz": new_cat.subtype_uz, "lasttype_uz": new_cat.lasttype_uz}):
        raise HTTPException(status_code=403)
    try:
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    #---main categories
    current_catecories = users_collection.distinct("name_ru")
    current_catecories_id = users_collection.distinct("id_name")
    if new_cat.main_ru in current_catecories:
        main_index = users_collection.find_one({"name_ru": new_cat.main_ru})['id_name']
    else:
        if len(current_catecories) == 0 :
            main_index = 1
        else:
            main_index = current_catecories_id[-1] + 1
    #---subtype
    current_catecories= users_collection.distinct("subtype_ru", {"name_ru": new_cat.main_ru})
    current_catecories_index = users_collection.distinct("index_subtype",{"name_ru": new_cat.main_ru})
    if new_cat.subtype_ru in current_catecories:
        subttype_categories = users_collection.find_one({"name_ru": new_cat.main_ru, "subtype_ru": new_cat.subtype_ru})
        id_subtype = subttype_categories['id_subtype']
        index_subtype = subttype_categories['index_subtype']
    else:
        if len(current_catecories) == 0 :
            id_subtype = str(main_index) + "1"
            index_subtype = 1
        else:
            index_subtype = current_catecories_index[-1] + 1
            id_subtype = str(main_index) + str(index_subtype)
    # ---- lasttype
    current_catecories = users_collection.distinct("lasttype_ru", {"name_ru": new_cat.main_ru, "subtype_ru": new_cat.subtype_ru})
    current_catecories_index = users_collection.distinct("index_lasttype", {"name_ru": new_cat.main_ru, "subtype_ru": new_cat.subtype_ru})
    if len(current_catecories) == 0 :
        id_lasttype = str(id_subtype + "1")
        index_lasttype = 1
    else:
        index_lasttype = current_catecories_index[-1] + 1
        id_lasttype = str(id_subtype) + str(index_lasttype)
    new_categories = {
        '_id': l + 1,
        'id_name': main_index,
        'name_ru': new_cat.main_ru,
        'name_uz': new_cat.main_uz,
        'id_subtype': str(id_subtype),
        'index_subtype' : index_subtype,
        'subtype_ru': new_cat.subtype_ru,
        'subtype_uz': new_cat.subtype_uz,
        'id_lasttype': str(id_lasttype),
        'index_lasttype': index_lasttype,
        'lasttype_ru': new_cat.lasttype_ru,
        'lasttype_uz': new_cat.lasttype_uz
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
    items = items_collection.find({"categories": current_cat['id_lasttype']})
    list_categories_value = []
    list_categories_value.append(edit_cat.main_ru)
    if edit_cat.subtype_ru and edit_cat.subtype_uz:
        list_categories_value.append(edit_cat.subtype_ru)
        if edit_cat.lasttype_ru and edit_cat.lasttype_uz:
            list_categories_value.append(edit_cat.lasttype_ru)
    for post in items:
        items_collection.update({"_id": post['_id']}, {'$set': {'categories_value': list_categories_value}})
    categories_collection.update_one({'_id': edit_cat.id}, {'$set': {'subtype_ru': edit_cat.subtype_ru, 'name_ru': edit_cat.main_ru,
                                                                     'lasttype_ru': edit_cat.lasttype_ru,
                                                                     'subtype_uz': edit_cat.subtype_uz, 'name_uz': edit_cat.main_uz,
                                                                     'lasttype_uz': edit_cat.lasttype_uz}})
    response.status_code = status.HTTP_200_OK
    return categories_collection.find_one({"_id": edit_cat.id})


@app.get("/api/v1/list_categories")
async def list_categories():
    cat_collection = db.categories_items
    list_categories = cat_collection.find()
    string_list_categories = []
    for post in list_categories:
        value_ru = []
        value_uz = []
        text_ru = post['name_ru']
        text_uz = post['name_uz']
        value_ru.append(post['name_ru'])
        value_uz.append(post['name_uz'])
        if post['subtype_ru'] and post['subtype_uz']:
            text_ru = text_ru + " - " + post['subtype_ru']
            text_uz = text_uz + " - " + post['subtype_uz']
            value_ru.append(post['subtype_ru'])
            value_uz.append(post['subtype_uz'])
        if post['lasttype_ru'] and post['lasttype_uz']:
            text_ru = text_ru + " - " + post['lasttype_ru']
            text_uz = text_uz + " - " + post['lasttype_uz']
            value_ru.append(post['lasttype_ru'])
            value_uz.append(post['lasttype_uz'])
        new_cat = {
            "id": post['_id'],
            "text_ru": text_ru,
            "text_uz": text_uz,
            "value_ru": value_ru,
            "value_uz": value_uz

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
#------------------------------ITEMS----------------------------------
#Add
@app.get("/api/v1/{language}/items_cat/{id}")
async def items_cat(id: str,language: str, response: Response):
    list_items = []
    items_collection = db.items
    items = items_collection.find({"categories": id}).sort("name", 1)
    for post in items:
        list_items.append(get_items_model(post,language))
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
        {"name_ru": new_item.categories[0], "subtype_ru": new_item.categories[1], "lasttype_ru": new_item.categories[2]})
    if not cur_cat:
        cur_cat = cat_collection.find_one(
            {"name_uz": new_item.categories[0], "subtype_uz": new_item.categories[1],
             "lasttype_uz": new_item.categories[2]})
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
    list_categories_value.append(cur_cat['name_ru'])
    if cur_cat['subtype_ru']:
        list_categories_value.append(cur_cat['subtype_ru'])
        if cur_cat['lasttype_ru']:
            list_categories_value.append(cur_cat['lasttype_ru'])
    discount = None
    if new_item.discount > 0:
            discount = new_item.discount
    new_i = {
        '_id': l + 1,
        "name_ru": new_item.name_ru,
        "name_uz": new_item.name_uz,
        "description_ru": new_item.description_ru,
        "description_uz": new_item.description_uz,
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

@app.get("/api/v1/{language}/items")
async def get_items(language:str,response: Response):
    users_collection = db.items
    all_items = users_collection.find()
    list_items = []
    for post in all_items:
        list_items.append(get_items_model(post,language))
    response.status_code = status.HTTP_200_OK
    return list_items

@app.get("/api/v1/items")
async def get_items(response: Response):
    users_collection = db.items
    all_items = users_collection.find()
    list_items = []
    link_collection = db.link_color
    for post in all_items:
        favorite_items = False
        if post['_id'] in list_user_favorites_items:
            favorite_items = True
        list_items.append(models.items_all_languages(id=post['_id'],
                            name_ru=post['name_ru'],
                            name_uz=post['name_uz'],
                            description_ru=post['description_ru'],
                            description_uz=post['description_uz'],
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
                            categories_value=post['categories_value']))
    response.status_code = status.HTTP_200_OK
    return list_items

@app.post("/api/v1/{language}/items_ind")
async def items_ind(index: list,language:str, response: Response):
    items_collection = db.items
    list_items = []
    for post in index:
        items = items_collection.find_one({"_id": int(post)})
        if items:
            list_items.append(get_items_model(items,language))
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
        {"name_ru": patch_item.categories[0], "subtype_ru": patch_item.categories[1], "lasttype_ru": patch_item.categories[2]})
    if not cur_cat:
        raise HTTPException(status_code=403)
    list_categories_value = []
    list_categories_value.append(cur_cat['name_ru'])
    if cur_cat['subtype_ru']:
        list_categories_value.append(cur_cat['subtype_ru'])
        if cur_cat['lasttype_ru']:
            list_categories_value.append(cur_cat['lasttype_ru'])
    id_link_color = link_collection.find_one({"color_link": {"$elemMatch": {"id": patch_item.id}}})['_id']
    discount = None
    if patch_item.discount > 0:
        discount = patch_item.discount
    current_item = users_collection.update_one({'_id': patch_item.id},
                                               {"$set": {"name_ru": patch_item.name_ru,
                                                         "name_uz": patch_item.name_uz,
                                                         "description_ru": patch_item.description_ru,
                                                         "description_uz": patch_item.description_uz,
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
    return models.patch_items(id=patch_item.id, name_ru=patch_item.name_ru,name_uz=patch_item.name_uz, description_ru=patch_item.description_ru,
                             description_uz=patch_item.description_uz,
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

@app.get("/api/v1/{language}/items/{id}")
async def get_items(id: int,language:str, response: Response):
    users_collection = db.items
    items = users_collection.find_one({"_id": id})
    if not items:
        raise HTTPException(status_code=403)
    response.status_code = status.HTTP_200_OK
    return get_items_model(items,language)

#------image

@app.post("/api/v1/uploadfile/")
async def create_upload_file(file: UploadFile = File(...)):
    try:
      with open('/app/images/' + file.filename, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    finally:
      file.file.close()
    return {"file_name": file.filename, "file_url":"https://mirllex.site/img/" + file.filename}




@app.post("/api/v1/del_file/")
async def create_upload_file(del_file:models.del_file):
    try:
        with open('/app/images/' + del_file.name, "wb") as buffer:
           os.remove(buffer.name)
    finally:
        return
    return


@app.get("/api/v1/{language}/search")
async def search(poisk: str,language:str, response: Response):
    items_collection = db.items
    list_of_items = []
    list_poisk_items = items_collection.find()
    for post in list_poisk_items:
        if poisk.lower() in post['name_ru'].lower() or poisk.lower() in post['name_uz'].lower():
            list_of_items.append(get_items_model(post,language))
    return list_of_items

def get_item_for_shopping_cart(id_user,language):
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": id_user})
    items_collection = db.items
    list_items_shopping_cart=[]
    for item in shopping_cart['items']:
        current_item = items_collection.find_one({"_id":item['id']})
        if language == "ru":
            list_items_shopping_cart.append(
             {'id': item['id'], 'name': current_item['name_ru'], 'size': item['size'], 'kol': item['kol'],
             'images': current_item['images'], 'color': current_item['color'], 'price': current_item['price'],
             'discount': current_item['discount']})
        elif language == "uz":
            list_items_shopping_cart.append(
                {'id': item['id'], 'name': current_item['name_uz'], 'size': item['size'], 'kol': item['kol'],
                 'images': current_item['images'], 'color': current_item['color'], 'price': current_item['price'],
                 'discount': current_item['discount']})
        else:
            raise HTTPException(status_code=404)
    return list_items_shopping_cart


@app.post("/api/v1/{language}/cart/addProduct")
async def add_Product_in_shopping_cart(add_product: models.product_in_sc,language:str, response: Response, request: Request):
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
            {'id': add_product.id, 'size': add_product.size, 'kol': add_product.kol})
        new_shopping_cart = {
            '_id': l + 1,
            'id_users': user['_id'],
            'items': list_of_items
        }
        shopping_cart_collection.insert_one(new_shopping_cart)
        return models.shopping_cart(id=l + 1,
                                    id_user=user['_id'],
                                    items=get_item_for_shopping_cart(user['_id'],language))
    else:
        list_of_items = shopping_cart['items']
        for post in list_of_items:
            if post['id'] == add_product.id and post['size'] == add_product.size:
                list_size_kol = items_collection.find_one({"_id":add_product.id})['size_kol']
                for item_size_kol in list_size_kol:
                    if item_size_kol['size'] == add_product.size:
                        if item_size_kol['kol'] >= add_product.kol + post['kol']:
                            shopping_cart_collection.update_one(
                                {"id_users": int(user['_id']), "items.id": add_product.id, "items.size": add_product.size},
                                {"$set": {"items.$.kol": add_product.kol + post['kol']}})
                        else:
                            shopping_cart_collection.update_one(
                                {"id_users": int(user['_id']), "items.id": add_product.id,
                                 "items.size": add_product.size},
                                {"$set": {"items.$.kol": item_size_kol['kol']}})

                return models.shopping_cart(id=shopping_cart['_id'],
                                            id_user=user['_id'],
                                            items=get_item_for_shopping_cart(user['_id'],language))
        shopping_cart_collection.update_one({"_id": shopping_cart['_id']},
                                            {"$push": {"items": {'id': add_product.id,
                                                                 'size': add_product.size,
                                                                 'kol': add_product.kol}}})
    return models.shopping_cart(id=shopping_cart['_id'],
                                id_user=user['_id'],
                                items=get_item_for_shopping_cart(user['_id'],language))




@app.get("/api/v1/{language}/cart/shopping_cart")
async def get_shopping_cart(language:str,response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    if not shopping_cart:
        return []
    items_collection = db.items
    list_items_in_shopping_cart = get_item_for_shopping_cart(user['_id'],language)
    list_shopping_items = []
    for post in list_items_in_shopping_cart:
        all_post_size_kol = items_collection.find_one({"_id":post['id']})['size_kol']
        for post_size_kol in all_post_size_kol:
            if post_size_kol['size'] == post['size']:
                post['stock'] = post_size_kol['kol']
        list_shopping_items.append(post)
    return models.shopping_cart(id=shopping_cart['_id'],
                                id_user=user['_id'],
                                items=list_shopping_items)

@app.post("/api/v1/cart/delproduct")
async def delete_Product_in_shopping_cart(del_items: models.del_product_in_sc, response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart_collection.update_one({"id_users": int(user['_id'])},
                                        {"$pull": {"items": {'id': del_items.id,
                                                             'size': del_items.size}}})
    return models.shopping_cart(id=shopping_cart_collection.find_one({"id_users": user['_id']})['_id'],
                                id_user=user['_id'],
                                items=get_item_for_shopping_cart(user['_id']))

@app.get("/api/v1/cart/paid")
async def pais_shoppting_cart(response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    if not shopping_cart:
        raise HTTPException(status_code=404)
    order_history_collectoin = db.order_history
    try:
        l = order_history_collectoin.distinct('_id')[-1]
    except:
        l = 0
    new_order = {
        "_id":l+1,
        "id_user": user['_id'],
        "date": datetime.now().strftime("%d-%m-%Y %H:%M"),
        "order": shopping_cart['items']
    }
    shopping_cart_collection.remove({"_id": shopping_cart['_id']})
    order_history_collectoin.insert_one(new_order)
    return new_order

@app.get("/api/v1/user_order")
async def user_order(response: Response, request: Request):
    user = check_auth_user(response, request)
    order_collection = db.order_history
    all_user_order = order_collection.find({"user_id": user['_id']})
    list_user_order = []
    for post in all_user_order:
        list_user_order.append(models.user_order(date=post['date'],items=post['items'],user_info=post['user_info'],
                                                 subtotal=post['subtotal'],shipping=post['shipping'],state=post['state'],shipping_adress=post['shipping_adress']))
    return list_user_order

@app.get("/api/v1/{language}/get_favourites")
async def get_favourites(language:str,response: Response, request: Request):
    user = check_auth_user(response, request)
    favourites_coll = db.favourites
    items_coll = db.items
    list_favourites = []
    favourites = favourites_coll.find_one({"id_user": user['_id']})
    if favourites:
        for index in favourites['list_favourites']:
            items = items_coll.find_one({"_id": index})
            if items:
                current_item = get_items_model(items,language)
                current_item.favorites = True
                list_favourites.append(current_item)

    return list_favourites

@app.post("/api/v1/add_favourites")
async def add_favourites (add_fav:models.index_favourites, response: Response, request: Request):
    user = check_auth_user(response, request)
    if not db.items.find_one({"_id":add_fav.id}):
        raise HTTPException(status_code=404)
    favourites_coll = db.favourites
    favourites_list = favourites_coll.find_one({"id_user": user['_id']})

    if not favourites_list:
        new_fav={
            "id_user": user['_id'],
            "list_favourites": [add_fav.id]
        }
        favourites_coll.insert_one(new_fav)
    else:
        if add_fav.id not in favourites_list['list_favourites']:
            favourites_coll.update({"id_user":user['_id']},
                                   {"$push":{"list_favourites":add_fav.id}})
    return  favourites_coll.find_one({"id_user": user['_id']})['list_favourites']

@app.post("/api/v1/del_favourites")
async def del_favourites (del_fav:models.index_favourites, response: Response, request: Request):
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
async def make_an_order(new_user_order:models.Order_registration,response: Response, request: Request):
    print(new_user_order)
    user = check_auth_user(response, request)
    items_collection = db.items
    number = uuid.uuid4()
    for item in new_user_order.list_items:
        all_item_size_kol = items_collection.find_one({"_id": item['id']})['size_kol']
        correctness = False
        for post_size_kol in all_item_size_kol:
            if post_size_kol['size'] == item['size']:
                if post_size_kol['kol'] < item['kol']:
                    raise HTTPException(status_code=409)
                else:
                    correctness = True
        if not correctness:
            raise HTTPException(status_code=404)
    return_url = Config.RETURN_URL + str(number)
    if new_user_order.which_bank == "payme":
       url_pay = "http"
    elif new_user_order.which_bank =="click":
        url_pay = Click.URL+ "&amount=" + str(new_user_order.subtotal) + "&transaction_param=" + user['email'] + \
                  "&return_url=" + return_url + "&card_type=" + new_user_order.cart_type
    else:
        raise HTTPException(status_code=404)
    order_collection = db.order_history
    new_order = {
        "_id" :str(number),
        "user_id":user['_id'],
        "user_info": new_user_order.client_info,
        "shipping_adress":new_user_order.shipping_adress,
        "items": new_user_order.list_items,
        "subtotal":new_user_order.subtotal,
        "date" : datetime.now().strftime("%d-%m-%Y %H:%M"),
        "shipping_type": new_user_order.shipping_type,
        "state" : "Awaiting payment"
    }
    order_collection.insert_one(new_order)
    for item in new_user_order.list_items:
        all_item_size_kol = items_collection.find_one({"_id": item['id']})['size_kol']
        for post_size_kol in all_item_size_kol:
            if post_size_kol['size'] == item['size']:
                if post_size_kol['kol'] - item['kol'] == 0:
                    items_collection.update_one({"_id": item['id']},
                           {"$pull": {"size_kol":{'size':item['size']}}})
                else:
                    items_collection.update_one({"_id": item['id'],"size_kol.size" : item['size']},
                          {"$set": {"size_kol.$.kol":post_size_kol['kol'] - item['kol']}})
    return url_pay
  
@app.get("/")
async def order_confirmation(uuid:str,payment_status:int,response: Response, request: Request):
    user = check_auth_user(response, request)
    order_collection = db.order_history
    order = order_collection.find_one({"_id":uuid})
    if not order:
        raise HTTPException(status_code=404)
    if order['state'] != "Awaiting payment":
        raise HTTPException(status_code=409)
    if user["_id"] != order['user_id']:
        raise HTTPException(status_code=409)
    items_collection = db.items
    if payment_status < 0:
        for item in order['items']:
            all_item_size_kol = items_collection.find_one({"_id": item['id']})['size_kol']
            correctness = False
            for post_size_kol in all_item_size_kol:
                if post_size_kol['size'] == item['size']:
                    items_collection.update_one({"_id": item['id'], "size_kol.size": item['size']},
                                                {"$set": {"size_kol.$.kol": post_size_kol['kol'] + item['kol']}})
                    correctness = True
            if not correctness:
                new_size_kol = {
                    "size":item['size'],
                    "kol": item['kol']
                }
                items_collection.update_one({"_id": item['id']},{"$push":{"size_kol":new_size_kol}})
        order_collection.remove({"_id": uuid})
        raise HTTPException(status_code=402)
    order_collection.update({"_id":uuid},{"$set":{"state":"Paid"}})
    shopping_cart_collection = db.shopping_cart
    shopping_cart_collection.remove({"id_users":user["_id"]})
    return order_collection.find_one({"_id":uuid})

@app.get("/api/v1/get_language")
async def get_language(language:str):
    if language == "ru":
        return ("ru")
    else:
        return("uz")