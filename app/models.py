from pydantic import BaseModel
from typing import Optional


class user(BaseModel):
    id: int
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: str


class userSignup(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: str
    phone: str
    password: str


class userSignin(BaseModel):
    email: str
    password: str


class userUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    password: Optional[str] = None


class categories(BaseModel):
    id: str
    name: str
    subtype: list


class subtype(BaseModel):
    id: str
    name_subtype: str


class new_categories(BaseModel):
    main: str
    subtype: Optional[str] = None
    lasttype: Optional[str] = None


class patch_categories(BaseModel):
    id: int
    main: Optional[str] = None
    subtype: Optional[str] = None
    lasttype: Optional[str] = None


class add_items(BaseModel):
    name: str
    description: str
    size_kol: list
    color: str
    images: list
    price: float
    discount: int
    hit_sales: bool
    special_offer: bool
    categories: list
    link_color: list
    name_images: Optional[list] = None


class patch_items(BaseModel):
    id: int
    name: Optional[str] = None
    description: Optional[str] = None
    size_kol: Optional[list] = None
    color: Optional[str] = None
    images: Optional[list] = None
    price: Optional[float] = None
    discount: Optional[int] = None
    hit_sales: Optional[bool] = None
    special_offer: Optional[bool] = None
    categories: Optional[list] = None
    link_color: Optional[list] = None
    name_images: Optional[list] = None


class items(BaseModel):
    id: str
    name: str
    description: str
    size_kol: list
    color: str
    images: list
    price: float
    discount: Optional[int] = None
    hit_sales: bool
    special_offer: bool
    categories: list
    link_color: list
    favorites: Optional[bool] = None
    categories_value: Optional[list] = None
    name_images: Optional[list] = None


class cat_json_main(BaseModel):
    id: str
    name: str
    kol: Optional[int] = 0
    subcategories: list


class cat_json(BaseModel):
    id: str
    name: str
    subcategories: list


class shopping_cart(BaseModel):
    id: int
    id_user: int
    items: list


class product_in_sc(BaseModel):
    id: int
    size: str
    kol: int


class del_product_in_sc(BaseModel):
    id: int
    size: str


class user_order(BaseModel):
    date: str
    order: list


class del_file(BaseModel):
    name: str


class index_favourites(BaseModel):
    id: int


class favourites(BaseModel):
    id_user: int
    list_favourites: list

class Name_Items(BaseModel):
    name: str

class Delete_categories(BaseModel):
    id:int

class Order_registration(BaseModel):
    number_order:int
