from pymongo import MongoClient
from models.Items import*
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop
list_user_favorites_items=[]


def get_items_model(post):
    link_collection = db.link_color
    favorite_items = False
    if post['_id'] in list_user_favorites_items:
        favorite_items = True
    return items(id=post['_id'],
                  name=post['name'],
                  description=post['description'],
                  size_kol=post['size_kol'],
                  color=post['color'],
                  images=post['images'],
                  name_images= post['name_images'],
                  price=post['price'],
                  discount=post['discount'],
                  hit_sales=post['hit_sales'],
                  special_offer=post['special_offer'],
                  categories=post['categories'],
                  link_color=link_collection.find_one({"_id": post['link_color']})['color_link'],
                  favorites=favorite_items,
                  categories_value =post['categories_value'])
