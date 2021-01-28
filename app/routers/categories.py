from fastapi import APIRouter
from starlette import status
from services.items import*
from services.auth import*
from models.categories import*
from services.files import*
router = APIRouter()
client = MongoClient('localhost', 27017, username='root', password='example')
db = client.zarinshop



@router.get("/api/v1/categories")
async def categories(request:Request, response: Response):
    global list_user_favorites_items
    try:
        if request.headers['authorization']:
            user = get_current_session_user(request.headers['authorization'][7:])
            list_favorites = db.favourites.find_one({"id_user": user['_id']})
            if list_favorites:
                list_user_favorites_items = list_favorites['list_favourites']
    except:
        print(list_user_favorites_items)
    users_collection = db.categories_items
    item_collection = db.items
    cat = users_collection.distinct('name')
    list_of_categories = []

    for p_main in cat:

        id_name = users_collection.find_one({'name': p_main})['id_name']

        if item_collection.find({"categories": str(id_name)}).count() != 0:
            p_m = cat_json_main(id=id_name,
                                       kol=item_collection.find({"categories": str(id_name)}).count(), name=p_main,
                                       subcategories=[])
            for p_subtype in users_collection.distinct('subtype', {'name': p_main}):
                if p_subtype:
                    id_subtype = users_collection.find_one({'name': p_main, 'subtype': p_subtype})['id_subtype']
                    if item_collection.find({"categories": str(id_subtype)}).count() != 0:
                        p_s = cat_json(
                            id=str(users_collection.find_one({'name': p_main, 'subtype': p_subtype})['id_subtype']),
                            name=p_subtype, subcategories=[])
                        for p_last in users_collection.distinct('lasttype', {'name': p_main, 'subtype': p_subtype}):
                            if p_last:
                                id_lasttype = \
                                users_collection.find_one({'name': p_main, 'subtype': p_subtype, 'lasttype': p_last})[
                                    'id_lasttype']

                                if item_collection.find({"categories": str(id_lasttype)}).count() != 0:
                                    p_s.subcategories.append(cat_json(
                                        id=str(users_collection.find_one(
                                            {'name': p_main, 'subtype': p_subtype, 'lasttype': p_last})
                                               ['id_lasttype']), name=p_last, subcategories=[]))
                        p_m.subcategories.append(p_s)
            list_of_categories.append(p_m)
    response.status_code = status.HTTP_200_OK
    return list_of_categories


@router.post("/api/v1/categories")
async def add_categories(new_cat: new_categories, response: Response):
    users_collection = db.categories_items
    if users_collection.find_one({"name": new_cat.main, "subtype": new_cat.subtype, "lasttype": new_cat.lasttype}):
        raise HTTPException(status_code=403)
    try:
        l = users_collection.distinct('_id')[-1]
    except:
        l = 0
    # ---main categories
    current_catecories = users_collection.distinct("name")
    current_catecories_id = users_collection.distinct("id_name")
    if new_cat.main in current_catecories:
        main_index = users_collection.find_one({"name": new_cat.main})['id_name']
    else:
        if len(current_catecories) == 0:
            main_index = 1
        else:
            main_index = current_catecories_id[-1] + 1
    # ---subtype
    current_catecories = users_collection.distinct("subtype", {"name": new_cat.main})
    current_catecories_index = users_collection.distinct("index_subtype", {"name": new_cat.main})
    if new_cat.subtype in current_catecories:
        subttype_categories = users_collection.find_one({"name": new_cat.main, "subtype": new_cat.subtype})
        id_subtype = subttype_categories['id_subtype']
        index_subtype = subttype_categories['index_subtype']
    else:
        if len(current_catecories) == 0:
            id_subtype = str(main_index) + "1"
            index_subtype = 1
        else:
            index_subtype = current_catecories_index[-1] + 1
            id_subtype = str(main_index) + str(index_subtype)
    # ---- lasttype
    current_catecories = users_collection.distinct("lasttype", {"name": new_cat.main, "subtype": new_cat.subtype})
    current_catecories_index = users_collection.distinct("index_lasttype",
                                                         {"name": new_cat.main, "subtype": new_cat.subtype})
    if len(current_catecories) == 0:
        id_lasttype = str(id_subtype + "1")
        index_lasttype = 1
    else:
        index_lasttype = current_catecories_index[-1] + 1
        id_lasttype = str(id_subtype) + str(index_lasttype)

    new_categories = {
        '_id': l + 1,
        'id_name': main_index,
        'name': new_cat.main,

        'id_subtype': str(id_subtype),
        'index_subtype': index_subtype,
        'subtype': new_cat.subtype,

        'id_lasttype': str(id_lasttype),
        'index_lasttype': index_lasttype,
        'lasttype': new_cat.lasttype,
    }
    users_collection.insert_one(new_categories)
    response.status_code = status.HTTP_201_CREATED
    return new_categories


@router.patch("/api/v1/categories")
async def edit_categories(edit_cat: patch_categories, response: Response):
    categories_collection = db.categories_items
    items_collection = db.items
    current_cat = categories_collection.find_one({"_id": edit_cat.id})
    if not current_cat:
        raise HTTPException(status_code=403)
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
    return patch_categories(id=str(edit_cat.id), name=edit_cat.main, subtype=edit_cat.subtype,
                                   lasttype=edit_cat.lasttype)


@router.get("/api/v1/list_categories")
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

@router.delete("/api/v1/categories")
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