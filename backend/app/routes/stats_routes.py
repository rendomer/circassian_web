# routes/stats_routes.py
from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import func, select

from app.database import get_async_session
from app.models.user_model import User

router = APIRouter(prefix="/api/stats", tags=["Figure"])

@router.get("/registered_users_count")
async def get_registered_users_count(db: AsyncSession = Depends(get_async_session)):
    total_registered_query = select(func.count()).select_from(User)
    total_registered = (await db.execute(total_registered_query)).scalar_one()

    deactivated_query = select(func.count()).select_from(User).where(User.is_active == False)
    total_deactivated = (await db.execute(deactivated_query)).scalar_one()

    return {
        "total_registered": total_registered,
        "total_deactivated": total_deactivated,
        "active_users": total_registered - total_deactivated
    }
