# app/services/reset_password_service.py

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user_model import User
from app.services.email_service import email_service
from app.utils.reset_code_generator import generate_reset_code

reset_codes = {}


async def request_password_reset_service(data, db: AsyncSession):
    query = select(User).where(User.email == data.email)
    result = await db.execute(query)
    user = result.scalars().first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    code = generate_reset_code()
    reset_codes[data.email] = code

    subject = "Восстановление пароля"
    body = f"Здравствуйте, {user.first_name}!\n\nВаш код для восстановления пароля: {code}\n\nЕсли это были не вы — проигнорируйте это письмо."

    email_service.send_email(user.email, subject, body)

    return {"message": "Reset code sent to your email."}


async def reset_password_service(data, db: AsyncSession):
    if reset_codes.get(data.email) != data.code:
        raise HTTPException(status_code=400, detail="Invalid reset code")

    query = select(User).where(User.email == data.email)
    result = await db.execute(query)
    user = result.scalars().first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.hashed_password = User.hash_password(data.new_password)
    await db.commit()

    del reset_codes[data.email]

    return {"message": "Password successfully reset."}
