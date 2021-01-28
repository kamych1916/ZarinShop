import random
from fastapi import HTTPException,APIRouter
from fastapi import Response
from starlette import status
from services.items import*
router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop


@router.get("/api/v1/hit_sales")
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

@router.get("/api/v1/special_offer")
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

@router.get("/api/v1/items_cat/{id}")
async def items_cat(id:str,response: Response):
    list_items=[]
    items_collection = db.items
    items = items_collection.find({"categories":id}).sort("name",1)
    for post in items:
        list_items.append(get_items_model(post))
    return list_items


@router.get("/api/v1/items")
async def get_items(response: Response):
    users_collection = db.items
    link_collection = db.link_color
    cotegories_collectoin = db.categories_items
    all_items = users_collection.find()
    list_items = []
    for post in all_items:
       list_items.append(get_items_model(post))
    response.status_code = status.HTTP_200_OK
    return list_items

@router.post("/api/v1/items_ind")
async def items_ind(index:list,response: Response):
    items_collection = db.items
    link_collection = db.link_color
    list_items = []
    for post in index:
        items= items_collection.find_one({"_id":int(post)})
        if items:
            list_items.append(get_items_model(items))
    return list_items


@router.post("/api/v1/items")
async def add_items(new_item: add_items, response: Response):
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
    new_i = {
        '_id': l + 1,
        "name": new_item.name,
        "description": new_item.description,
        "size_kol": new_item.size_kol,
        "color": new_item.color,
        "images": new_item.images,
        "price": new_item.price,
        "discount": new_item.discount,
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


# edit items
@router.patch("/api/v1/items")
async def patch_items(patch_item: patch_items, response: Response):
    users_collection = db.items
    link_collection = db.link_color
    if not  users_collection.find_one({"_id": patch_item.id}):
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
    current_item = users_collection.update_one({'_id': patch_item.id},
                                               {"$set": {"name": patch_item.name,
                                                         "description": patch_item.description,
                                                         "size_kol": patch_item.size_kol,
                                                         "color": patch_item.color,
                                                         "images": patch_item.images,
                                                         "price": patch_item.price,
                                                         "discount": patch_item.discount,
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
    return items(id=patch_item.id, name=patch_item.name, description=patch_item.description,
                        size_kol=patch_item.size_kol,
                        color=patch_item.color, images=patch_item.images, price=patch_item.price,
                        discount=patch_item.discount,
                        hit_sales=patch_item.hit_sales, special_offer=patch_item.special_offer,
                        categories=[str(cur_cat['id_name']), str(cur_cat['id_subtype']), str(cur_cat['id_lasttype'])],
                        link_color=link_collection.find_one({"_id": id_link_color})['color_link'])


@router.delete("/api/v1/items")
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


@router.get("/api/v1/items/{id}")
async def get_items(id: int, response: Response):
    users_collection = db.items
    items = users_collection.find_one({"_id": id})
    if not items:
        raise HTTPException(status_code=403)
    response.status_code = status.HTTP_200_OK
    return get_items_model(items)

@router.get("/api/v1/search")
async def search(poisk: str, response: Response):
    items_collection = db.items
    list_of_items = []
    list_poisk_items = items_collection.find()
    for post in list_poisk_items:
        if poisk.lower() in post['name'].lower():
            list_of_items.append(get_items_model(post))
    return list_of_items
