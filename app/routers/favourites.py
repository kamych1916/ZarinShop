from fastapi import APIRouter, HTTPException
from fastapi import Response
from pymongo import MongoClient
from starlette.requests import Request
from services.auth import check_auth_user
from models.Items import items
from models.favourites import*
router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop

@router.get("/api/v1/get_favourites")
async def get_favourites (response: Response, request: Request):
    user = check_auth_user(response, request)
    favourites_coll = db.favourites
    items_coll= db.items
    link_collection = db.link_color
    list_favourites=[]
    favourites =favourites_coll.find_one({"id_user":user['_id']})
    if favourites:
        for index in favourites['list_favourites']:
            current_items = items_coll.find_one({"_id":index})
            if current_items:
                list_favourites.append(items(id=current_items['_id'], name=current_items['name'], description=current_items['description'],
                                                  size_kol=current_items['size_kol'], color=current_items['color'],
                                                  images=current_items['images'], price=current_items['price'], discount=current_items['discount'],
                                                  hit_sales=current_items['hit_sales'], special_offer=current_items['special_offer'],
                                                  categories=current_items['categories'],
                                                  link_color=link_collection.find_one({"_id": current_items['link_color']})[
                                                      'color_link'],favorites = True))
    return list_favourites

@router.post("/api/v1/add_favourites")
async def add_favourites (add_fav:index_favourites, response: Response, request: Request):
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

@router.post("/api/v1/del_favourites")
async def del_favourites (del_fav:index_favourites, response: Response, request: Request):
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

