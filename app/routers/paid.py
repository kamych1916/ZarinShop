import datetime
import uuid
from fastapi import APIRouter, HTTPException
from fastapi import Response
from pymongo import MongoClient
from starlette.requests import Request
from services.auth import check_auth_user
from models.paid import*
from config.paid import Config,Click
router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop

@router.post("/api/v1/make_an_order")
async def make_an_order(new_user_order: Order_registration, response: Response, request: Request):
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
    elif new_user_order.which_bank == "click":
        url_pay = Click.URL + "&amount=" + str(new_user_order.subtotal) + "&transaction_param=" + user['email'] + \
                  "&return_url=" + return_url + "&card_type=" + new_user_order.cart_type
    else:
        raise HTTPException(status_code=404)
    order_collection = db.order_history
    new_order = {
        "_id": str(number),
        "user_id": user['_id'],
        "user_info": new_user_order.client_info,
        "shipping_adress": new_user_order.shipping_adress,
        "items": new_user_order.list_items,
        "subtotal": new_user_order.subtotal,
        "date": datetime.now().strftime("%d-%m-%Y %H:%M"),
        "shipping_type": new_user_order.shipping_type,
        "state": "Awaiting payment"
    }
    order_collection.insert_one(new_order)
    for item in new_user_order.list_items:
        all_item_size_kol = items_collection.find_one({"_id": item['id']})['size_kol']
        for post_size_kol in all_item_size_kol:
            if post_size_kol['size'] == item['size']:
                if post_size_kol['kol'] - item['kol'] == 0:
                    items_collection.update_one({"_id": item['id']},
                                                {"$pull": {"size_kol": {'size': item['size']}}})
                else:
                    items_collection.update_one({"_id": item['id'], "size_kol.size": item['size']},
                                                {"$set": {"size_kol.$.kol": post_size_kol['kol'] - item['kol']}})
    return url_pay


@router.get("/")
async def order_confirmation(uuid: str, payment_status: int, response: Response, request: Request):
    user = check_auth_user(response, request)
    order_collection = db.order_history
    order = order_collection.find_one({"_id": uuid})
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
                    "size": item['size'],
                    "kol": item['kol']
                }
                items_collection.update_one({"_id": item['id']}, {"$push": {"size_kol": new_size_kol}})
        order_collection.remove({"_id": uuid})
        raise HTTPException(status_code=402)
    order_collection.update({"_id": uuid}, {"$set": {"state": "Paid"}})
    shopping_cart_collection = db.shopping_cart
    shopping_cart_collection.remove({"id_users": user["_id"]})
    return order_collection.find_one({"_id": uuid})
