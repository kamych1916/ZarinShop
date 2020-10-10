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
    password: str

class userSignin(BaseModel):
    email: str
    password: str

class userUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None


class categories (BaseModel):
    id:str
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
    name: Optional[str] = None
    subtype: Optional[str] = None

class add_items(BaseModel):
    name: str
    description: str
    image: str
    price: float
    discount:int
    hit_sales: bool
    special_offer: bool
    categories: list

class patch_items(BaseModel):
    id: str
    name: Optional[str] = None
    description: Optional[str] = None
    image: Optional[str] = None
    price: Optional[float] = None
    discount: Optional[int] = None
    hit_sales: Optional[bool] = None
    special_offer: Optional[bool] = None
    categories: Optional[list] = None

class cat_json(BaseModel):
    id: str
    name:str
    subcategories: list



