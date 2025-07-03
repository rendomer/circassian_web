# main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes.ping_routes import router as ping_router
from app.routes.user_routes import router as user_router
from app.routes.reset_password_routes import router as reset_password_router
from app.routes.email_routes import router as email_router
from app.routes.statistics_routes import router as statistics_router
from app.routes.survey_routes import router as survey_router
from app.database import init_models
from app.routes import debug_routes
from app.routes import stats_routes
from app.routes import people_routes

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def on_startup():
    await init_models()

app.include_router(ping_router)
app.include_router(user_router, prefix="/api/users", tags=["users"])
app.include_router(reset_password_router, prefix="/api/reset-password", tags=["reset-password"])
app.include_router(email_router)
app.include_router(statistics_router, prefix="/api", tags=["statistics"])
app.include_router(survey_router, prefix="/api/surveys", tags=["surveys"])
app.include_router(debug_routes.router)
app.include_router(stats_routes.router)
app.include_router(people_routes.router, prefix="/api/people", tags=["People"])

@app.get("/")
async def root():
    return {"message": "Сервер работает!"}
