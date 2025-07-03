from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func, insert, and_
from datetime import datetime

from app.database import get_db
from app.schemas.user_schema import UserCreate, UserLogin
from app.schemas.reset_password_schema import PasswordResetRequest, PasswordResetConfirm
from app.services.user_service import register_user_service, login_user_service
from app.services.reset_password_service import request_password_reset_service, reset_password_service
from app.models.user_model import User
from app.models.confirmation_model import Confirmation

router = APIRouter(tags=["users"])

@router.post("/register")
async def register_user(user_data: UserCreate, db: AsyncSession = Depends(get_db)):
    user = await register_user_service(user_data, db)
    return {"message": "Регистрация успешна", "user_id": user.id}

@router.post("/login")
async def login_user(login_data: UserLogin, db: AsyncSession = Depends(get_db)):
    user = await login_user_service(login_data, db)
    return {"message": "Вход выполнен успешно", "user_id": user.id}

@router.get("/list")
async def list_users(confirmed_by: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User))
    users = result.scalars().all()

    data = []
    for user in users:
        # сколько всего подтверждений
        res = await db.execute(
            select(func.count()).select_from(Confirmation).where(Confirmation.user_id == user.id)
        )
        total = res.scalar()

        # я подтвердил этого пользователя?
        exists = await db.execute(
            select(Confirmation).where(
                and_(
                    Confirmation.user_id == user.id,
                    Confirmation.confirmed_by == confirmed_by
                )
            )
        )
        i_have_confirmed = bool(exists.scalar())

        data.append({
            "user_id": str(user.id),
            "first_name": user.first_name,
            "last_name": user.last_name,
            "email": user.email,
            "phone": user.phone,
            "children_count": user.children_count,
            "confirmations_count": total,
            "i_have_confirmed": i_have_confirmed
        })

    return data

@router.post("/confirm/{user_id}")
async def confirm_user_by_id(
    user_id: str,
    body: dict = Body(...),
    db: AsyncSession = Depends(get_db)
):
    confirmed_by = body.get("confirmed_by")
    if not confirmed_by:
        raise HTTPException(status_code=400, detail="confirmed_by is required")

    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # проверяем, подтверждал ли раньше
    exists = await db.execute(
        select(Confirmation).where(
            and_(
                Confirmation.user_id == user_id,
                Confirmation.confirmed_by == confirmed_by
            )
        )
    )
    if exists.scalar():
        raise HTTPException(status_code=400, detail="Вы уже подтверждали этого пользователя!")

    stmt = insert(Confirmation).values(
        user_id=user_id,
        confirmed_by=confirmed_by,
        confirmed_at=datetime.utcnow()
    )
    await db.execute(stmt)
    await db.commit()

    result = await db.execute(
        select(func.count()).select_from(Confirmation).where(Confirmation.user_id == user_id)
    )
    total = result.scalar()

    return {
        "message": "Confirmation added",
        "user_id": user_id,
        "total_confirmations": total
    }

@router.post("/request-password-reset")
async def request_password_reset(data: PasswordResetRequest, db: AsyncSession = Depends(get_db)):
    return await request_password_reset_service(data, db)

@router.post("/reset-password")
async def reset_password(data: PasswordResetConfirm, db: AsyncSession = Depends(get_db)):
    return await reset_password_service(data, db)
