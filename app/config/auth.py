class Config(object):
    SECRET_KEY = "yixozKubgLhKyEpO8WOjvKfxRk7JauP3PMxv2uWfonCEyzEct2J5SaMvm1WpDfks"
    SECRET_KEY_PASSWORD = b'\x95\x08\xbbGn\x97\xce\x8c\xb4w\xe84p\x90$\x9aU\xa6\x0cpqF\xb0\x11\xc9\x9a\x18JJ@\xec\xc0'
    SECRET_KEY_ACIVE = 'Cn9OGbn8KSXd8ZUGTeBCKnlZ37ooaec1QooL3IFB682DYR213GNt1fO33Mh3fQEs'
    ALGORITHM = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES = 30
    ADMIN_LIST=[2,48]
    ADMIN_URL = ["docs","/api/v1/categories","/api/v1/items","/api/v1/uploadfile/","/api/v1/del_file/"]


