from sqlalchemy import Column, String, Boolean, Integer, Text, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
import uuid

from app.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    email = Column(String(255), unique=True, nullable=False)
    phone = Column(String(20), unique=True)
    password = Column(Text, nullable=False)
    is_deceased = Column(Boolean, default=False)  # <-- добавь его, если хочешь это поле
    photo_url = Column(Text)
    confirmed = Column(Boolean, default=False)
    death_confirmed = Column(Boolean, default=False)  # ← ОБЯЗАТЕЛЬНО должна быть
    deactivation_note = Column(Text)
    is_active = Column(Boolean, default=True)
    father_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    mother_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    children_count = Column(Integer, default=0)
