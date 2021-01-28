from pydantic import BaseModel


class index_favourites(BaseModel):
    id: int


class favourites(BaseModel):
    id_user: int
    list_favourites: list
