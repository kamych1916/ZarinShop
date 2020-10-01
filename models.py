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

