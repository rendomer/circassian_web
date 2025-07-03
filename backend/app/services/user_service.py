# services/user_service.py

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import or_
from fastapi import HTTPException, status
from app.models.user_model import User
from app.utils.security import hash_password, verify_password
from app.schemas.user_schema import UserCreate, UserLogin


async def register_user_service(user_data: UserCreate, db: AsyncSession):
    query = select(User).where(
        (User.email == user_data.email) |
        ((User.phone == user_data.phone) & (user_data.phone is not None))
    )
    result = await db.execute(query)
    existing_user = result.scalars().first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User already exists")

    new_user = User(
        first_name=user_data.first_name,
        last_name=user_data.last_name,
        email=user_data.email,
        phone=user_data.phone,
        password=hash_password(user_data.password),
        is_active=True,
        is_deceased=False,
        confirmed=False,
        children_count=0,
        father_id=None,
        mother_id=None,
        deactivation_note=None,
        death_confirmed=False,
    )
    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)
    return new_user


async def login_user_service(login_data: UserLogin, db: AsyncSession):
    query = select(User).where(
        or_(
            User.email == login_data.email_or_phone,
            User.phone == login_data.email_or_phone
        )
    )
    result = await db.execute(query)
    user = result.scalars().first()
    if not user or not verify_password(login_data.password, user.password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail="Неверный email/телефон или пароль")
    return user


async def get_user_by_login(db: AsyncSession, email_or_phone: str) -> User | None:
    query = select(User).where(
        or_(
            User.email == email_or_phone,
            User.phone == email_or_phone
        )
    )
    result = await db.execute(query)
    return result.scalars().first()
