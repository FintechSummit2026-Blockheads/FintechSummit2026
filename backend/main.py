from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from endpoints import user, restaurant, general

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(
    user.router,
    prefix = "/user"
)

app.include_router(
    restaurant.router,
    prefix = "/restaurant"
)

app.include_router(
    general.router,
    prefix = "/general"
)

@app.get("/")
def read_root():
    return {"Hello": "World"}
