from fastapi import APIRouter, HTTPException
from fastapi import Response
from pymongo import MongoClient
from starlette.requests import Request

from services.auth import check_auth_user
from models.shopping_cart import*
from services.shopping_cart import*
router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop


@router.post("/api/v1/cart/addProduct")
async def add_Product_in_shopping_cart(add_product: product_in_sc, response: Response, request: Request):
    user = check_auth_user(response, request)
    items_collection = db.items
    shopping_cart_collection = db.shopping_cart
    current_shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    items = items_collection.find_one({"_id": add_product.id})
    if not items:
        raise HTTPException(status_code=403)
    find = False
    for element_size_kol in items['size_kol']:
        if element_size_kol['size'] == add_product.size:
            find=True
    if not find:
        raise HTTPException(status_code=403)
    try:
        l = shopping_cart_collection.distinct('_id')[-1]
    except:
        l = 0
    if not current_shopping_cart:
        list_of_items = []
        list_of_items.append(
            {'id': add_product.id, 'size': add_product.size, 'kol': add_product.kol})
        new_shopping_cart = {
            '_id': l + 1,
            'id_users': user['_id'],
            'items': list_of_items
        }
        shopping_cart_collection.insert_one(new_shopping_cart)
        return shopping_cart(id=l + 1,
                                    id_user=user['_id'],
                                    items=get_item_for_shopping_cart(user['_id']))
    else:
        list_of_items = current_shopping_cart['items']
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

                return shopping_cart(id=current_shopping_cart['_id'],
                                            id_user=user['_id'],
                                            items=get_item_for_shopping_cart(user['_id']))
        shopping_cart_collection.update_one({"_id": current_shopping_cart['_id']},
                                            {"$push": {"items": {'id': add_product.id,
                                                                 'size': add_product.size,
                                                                 'kol': add_product.kol}}})
    return shopping_cart(id=current_shopping_cart['_id'],
                                id_user=user['_id'],
                                items=get_item_for_shopping_cart(user['_id']))


@router.get("/api/v1/cart/shopping_cart")
async def get_shopping_cart(response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    current_shopping_cart = shopping_cart_collection.find_one({"id_users": user['_id']})
    if not current_shopping_cart:
        return []
    items_collection = db.items
    list_items_in_shopping_cart = get_item_for_shopping_cart(user['_id'])
    list_shopping_items = []
    for post in list_items_in_shopping_cart:
        all_post_size_kol = items_collection.find_one({"_id":post['id']})['size_kol']
        for post_size_kol in all_post_size_kol:
            if post_size_kol['size'] == post['size']:
                post['stock'] = post_size_kol['kol']
        list_shopping_items.append(post)
    return shopping_cart(id=current_shopping_cart['_id'],
                                id_user=user['_id'],
                                items=list_shopping_items)

@router.post("/api/v1/cart/delproduct")
async def delete_Product_in_shopping_cart(del_items: del_product_in_sc, response: Response, request: Request):
    user = check_auth_user(response, request)
    shopping_cart_collection = db.shopping_cart
    shopping_cart_collection.update_one({"id_users": int(user['_id'])},
                                        {"$pull": {"items": {'id': del_items.id,
                                                             'size': del_items.size}}})
    return shopping_cart(id=shopping_cart_collection.find_one({"id_users": user['_id']})['_id'],
                                id_user=user['_id'],
                                items=get_item_for_shopping_cart(user['_id']))
