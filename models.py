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
    name: str
    subtype: str

class patch_categories(BaseModel):
    name: Optional[str] = None
    subtype: Optional[str] = None


