# app/routes/statistics_routes.py

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from app.database import get_db
from app.models.user_model import User
from app.models.children_model import Child  # если у тебя отдельная модель children есть

router = APIRouter(
    prefix="/statistics",
    tags=["statistics"]
)


@router.get("/")
async def get_statistics(db: AsyncSession = Depends(get_db)):
    # Основные данные о пользователях
    total_users = (await db.execute(select(func.count()).select_from(User))).scalar()
    active_users = (await db.execute(select(func.count()).select_from(User).where(User.is_active == True))).scalar()
    confirmed_users = (await db.execute(select(func.count()).select_from(User).where(User.confirmed == True))).scalar()
    death_confirmed = (await db.execute(select(func.count()).select_from(User).where(User.death_confirmed == True))).scalar()
    deactivated_users = (await db.execute(select(func.count()).select_from(User).where(User.is_active == False))).scalar()

    # Количество реальных (живых)
    real_users = total_users - death_confirmed

    # Количество отцов и матерей (не NULL)
    fathers_count = (await db.execute(select(func.count()).select_from(User).where(User.father_id.isnot(None)))).scalar()
    mothers_count = (await db.execute(select(func.count()).select_from(User).where(User.mother_id.isnot(None)))).scalar()

    # Количество детей — по полю children_count
    children_total = (await db.execute(select(func.sum(User.children_count)))).scalar() or 0

    # Или если отдельная таблица `children` — использовать:
    # children_total = (await db.execute(select(func.count()).select_from(Child))).scalar()

    return {
        "total_users": total_users,
        "real_users": real_users,
        "active_users": active_users,
        "confirmed_users": confirmed_users,
        "death_confirmed": death_confirmed,
        "deactivated_users": deactivated_users,
        "fathers_count": fathers_count,
        "mothers_count": mothers_count,
        "children_total": children_total
    }