
from pydantic import BaseModel


class user_order(BaseModel):
    id: str
    date: str
    items: list
    user_info: str
    shipping_adress: str
    subtotal:int
    shipping_type:str
    state:str


