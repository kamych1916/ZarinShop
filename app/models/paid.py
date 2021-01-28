from typing import Optional

from pydantic import BaseModel


class Order_registration(BaseModel):
    list_items: Optional[list] = None
    which_bank: str
    client_info: list
    shipping_adress: str
    subtotal: int
    shipping_type: str
    cart_type: str
