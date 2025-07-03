# routes/debug_routes.py

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.database import get_async_session
from app.models.user_model import User
from app.utils.security import verify_password

router = APIRouter(prefix="/debug", tags=["Debug"])

# 1. Получить всех пользователей (email + хэш пароля)
@router.get("/users")
async def get_all_users(db: AsyncSession = Depends(get_async_session)):
    result = await db.execute(select(User))
    users = result.scalars().all()
    return [
        {
            "id": str(user.id),
            "email": user.email,
            "phone": user.phone,
            "first_name": user.first_name,
            "last_name": user.last_name,
            "password_hash": user.password,
        }
        for user in users
    ]

# 2. Проверить пароль для email или телефона
@router.post("/check-password")
async def check_password(email_or_phone: str, password: str, db: AsyncSession = Depends(get_async_session)):
    query = select(User).where((User.email == email_or_phone) | (User.phone == email_or_phone))
    result = await db.execute(query)
    user = result.scalars().first()
    if not user:
        return {"success": False, "reason": "User not found"}

    is_correct = verify_password(password, user.password)
    return {
        "success": is_correct,
        "user_id": str(user.id),
        "email": user.email,
        "phone": user.phone,
        "password_entered": password,
        "password_hash": user.password,
    }
