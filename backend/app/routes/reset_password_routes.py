# C:\cherkess_net\backend\app\routes\reset_password_routes.py

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_db
from app.schemas.reset_password_schema import PasswordResetRequest, PasswordResetConfirm
from app.services.reset_password_service import request_password_reset_service, reset_password_service

router = APIRouter(
    tags=["reset-password"]
)

@router.post("/request-reset")
async def request_password_reset(data: PasswordResetRequest, db: AsyncSession = Depends(get_db)):
    return await request_password_reset_service(data, db)

@router.post("/reset")
async def reset_password(data: PasswordResetConfirm, db: AsyncSession = Depends(get_db)):
    return await reset_password_service(data, db)
