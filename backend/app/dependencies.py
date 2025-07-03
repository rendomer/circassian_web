# app/dependencies.py

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from app.models.user_model import User
from app.database import get_async_session
from sqlalchemy.ext.asyncio import AsyncSession

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

async def get_current_user(token: str = Depends(oauth2_scheme), db: AsyncSession = Depends(get_async_session)) -> User:
    # Здесь вызов твоей функции, которая проверяет и расшифровывает JWT, возвращает User из базы
    user = await verify_token_and_get_user(token, db)  # Тебе нужно реализовать эту функцию!
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid authentication credentials")
    return user
