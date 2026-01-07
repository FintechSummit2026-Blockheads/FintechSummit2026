from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from endpoints import user

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
    prefix = "/login"
)

@app.get("/")
def read_root():
    return {"Hello": "World"}
