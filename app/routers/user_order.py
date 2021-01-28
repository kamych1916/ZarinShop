from fastapi import APIRouter, HTTPException
from fastapi import Response
from pymongo import MongoClient
from starlette.requests import Request
from services.auth import check_auth_user
from models.user_order import*
router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop

@router.get("/api/v1/user_order")
async def user_order(response: Response, request: Request):
    user = check_auth_user(response, request)
    order_collection = db.order_history
    all_user_order = order_collection.find({"user_id": user['_id']})
    list_user_order = []
    for post in all_user_order:
        list_user_order.append(user_order(id= post['_id'],date=post['date'],items=post['items'],user_info=post['user_info'],
                                                 subtotal=post['subtotal'],shipping_type=post['shipping'],state=post['state'],shipping_adress=post['shipping_adress']))
    return list_user_order

