from fastapi import FastAPI,Response
from pymongo import MongoClient
from fastapi.middleware.cors import CORSMiddleware
from starlette.requests import Request
from routers import auth, items, categories, files, shopping_cart, user_order,favourites,paid,mailing
from services.auth import check_auth_user_middleware
app = FastAPI()


@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    if not check_auth_user_middleware(request):
        return Response(status_code=403)
    response = await call_next(request)
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

app.include_router(auth.router)
app.include_router(items.router)
app.include_router(categories.router)
app.include_router(files.router)
app.include_router(shopping_cart.router)
app.include_router(user_order.router)
app.include_router(favourites.router)
app.include_router(paid.router)
app.include_router(mailing.router)


client = MongoClient('mongo', 27017, username='root', password='example')
db = client.zarinshop
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)






