#backend/schemas/user.py
from pydantic import BaseModel, EmailStr, constr
from uuid import UUID

class UserCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    phone: str | None = None
    password: constr(min_length=6)

class UserLogin(BaseModel):
    email_or_phone: str
    password: str

class UserResponse(BaseModel):
    id: UUID
    first_name: str
    last_name: str
    email: EmailStr
    phone: str | None = None
    is_deceased: bool
    confirmed: bool
    death_confirmed: bool

    class Config:
        orm_mode = True
