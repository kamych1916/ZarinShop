from pydantic import BaseModel
from typing import Optional


class new_categories(BaseModel):
    main: str
    subtype: Optional[str] = None
    lasttype: Optional[str] = None


class patch_categories(BaseModel):
    id: int
    main: Optional[str] = None
    subtype: Optional[str] = None
    lasttype: Optional[str] = None


class cat_json_main(BaseModel):
    id: str
    name: str
    kol: Optional[int] = 0
    subcategories: list


class cat_json(BaseModel):
    id: str
    name: str
    subcategories: list
