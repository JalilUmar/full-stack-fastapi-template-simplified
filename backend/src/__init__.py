from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from src.interfaces import postgres
from src.utils.logging import setup_logging

setup_logging()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # postgres.create_tables()
    yield


def create_app():
    app = FastAPI(lifespan=lifespan, prefix="/api/v1")
    # app = FastAPI(prefix="/api/v1")

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    return app


app = create_app()


@app.get("/health")
def read_root():
    return {"message": "I am Healthy :)"}


import os, logging


@app.get("/env")
def get_env():
    print(os.getenv("PG_DB_URL"))
    return {"env": os.environ}
