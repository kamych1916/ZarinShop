from typing import Optional

from pydantic import BaseModel


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

