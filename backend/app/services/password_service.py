import random
import string
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from fastapi import HTTPException
from app.models.user_model import User
from app.utils.security import hash_password
from app.utils.email_utils import send_email

reset_codes = {}  # временное хранилище


def generate_reset_code(length=6):
    return ''.join(random.choices(string.digits, k=length))


async def request_password_reset_service(data, db: AsyncSession):
    query = select(User).where(User.email == data.email)
    result = await db.execute(query)
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    code = generate_reset_code()
    reset_codes[data.email] = code

    send_email(
        to_email=data.email,
        subject="Password Reset Code",
        body=f"Your password reset code is: {code}"
    )

    return {"message": "Reset code sent to your email."}


async def reset_password_service(data, db: AsyncSession):
    if reset_codes.get(data.email) != data.code:
        raise HTTPException(status_code=400, detail="Invalid reset code")

    query = select(User).where(User.email == data.email)
    result = await db.execute(query)
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.password = hash_password(data.new_password)
    await db.commit()
    reset_codes.pop(data.email, None)
    return {"message": "Password has been reset successfully."}
