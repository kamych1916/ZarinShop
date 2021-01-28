from pydantic import BaseModel
from typing import Optional



class userSignup(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: str
    phone: str
    password: str


class userSignin(BaseModel):
    email: str
    password: str

class user(BaseModel):
    id: int
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: str


class userUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    password: Optional[str] = None
