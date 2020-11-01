from pydantic import BaseModel
from typing import Optional


class user(BaseModel):
    id:str
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


class categories (BaseModel):
    id:str
    name: str
    subtype: list
    image_url: str

class subtype(BaseModel):
    id: str
    name_subtype: str


class new_categories(BaseModel):
    main: str
    subtype: Optional[str] = None
    lasttype: Optional[str] = None
    image_url : str

class patch_categories(BaseModel):
    name: Optional[str] = None
    subtype: Optional[str] = None
    lasttype: Optional[str] = None
    image_url: Optional[str] = None

class add_items(BaseModel):
    name: str
    description: str
    size: list
    color: str
    image: list
    price: float
    discount:int
    hit_sales: bool
    special_offer: bool
    categories: list

class patch_items(BaseModel):
    id: int
    name: Optional[str] = None
    description: Optional[str] = None
    size:  Optional[list] = None
    color: Optional[str] = None
    image: Optional[list] = None
    price: Optional[float] = None
    discount: Optional[int] = None
    hit_sales: Optional[bool] = None
    special_offer: Optional[bool] = None
    categories: Optional[list] = None

class items(BaseModel):
    id: str
    name: str
    description: str
    size: list
    color: str
    image: list
    price: float
    discount: int
    hit_sales: bool
    special_offer: bool
    categories: list

class cat_json_main(BaseModel):
    id: str
    name:str
    kol : Optional[int] = 0
    image_url: Optional[str] = None
    subcategories: list

class cat_json(BaseModel):
    id: str
    name:str
    subcategories: list

class shopping_cart(BaseModel):
    id:int
    id_user: int
    items:list

class product_in_sc(BaseModel):
    id:int
    size: str
    kol: int

class del_product_in_sc(BaseModel):
    id:int
    size:str


