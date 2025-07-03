from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import get_async_session
from app.models.user_model import User
from sqlalchemy.future import select
from uuid import UUID
from fastapi import HTTPException, status

router = APIRouter()

@router.get("/all")
async def get_all_users(db: AsyncSession = Depends(get_async_session)):
    result = await db.execute(select(User))
    users = result.scalars().all()
    return [
        {
            "id": str(user.id),
            "first_name": user.first_name,
            "last_name": user.last_name,
            "email": user.email,
            "phone": user.phone,
            "children_count": user.children_count,
            "confirmed": user.confirmed,
            "is_active": user.is_active,
        }
        for user in users
    ]

@router.post("/{user_id}/confirm")
async def confirm_user(user_id: UUID, db: AsyncSession = Depends(get_async_session)):
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()

    if not user:
        raise HTTPException(status_code=404, detail="Пользователь не найден")

    user.confirmed = True
    await db.commit()
    await db.refresh(user)

    return {"message": "Пользователь подтвержден", "user_id": str(user.id)}
