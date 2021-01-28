from pydantic import BaseModel


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
