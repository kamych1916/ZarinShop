from pymongo import MongoClient

client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop

def get_item_for_shopping_cart(id_user):
    shopping_cart_collection = db.shopping_cart
    shopping_cart = shopping_cart_collection.find_one({"id_users": id_user})
    items_collection = db.items
    list_items_shopping_cart=[]
    for item in shopping_cart['items']:
        current_item = items_collection.find_one({"_id":item['id']})
        if current_item:
            list_items_shopping_cart.append(
             {'id': item['id'], 'name': current_item['name'], 'size': item['size'], 'kol': item['kol'],
             'images': current_item['images'], 'color': current_item['color'], 'price': current_item['price'],
             'discount': current_item['discount']})
    return list_items_shopping_cart
