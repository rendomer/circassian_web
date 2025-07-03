# app/database.py

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# ⚙️ Настройки подключения к БД

# Основная база
# DATABASE_URL = "sqlite+aiosqlite:///C:/cherkess_net/backend/db.sqlite3"
# Основная база, поставь имя правильно

# Тестовая база
DATABASE_URL = "postgresql+asyncpg://postgres:l@localhost:5432/cherkess_net"
# Тестовая база, поставь имя правильно


engine = create_async_engine(
    DATABASE_URL,
    echo=True,
    connect_args={"server_settings": {"client_encoding": "UTF8"}}
)

async_session = sessionmaker(
    bind=engine, class_=AsyncSession, expire_on_commit=False
)

Base = declarative_base()


async def init_models():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


async def get_db():
    async with async_session() as session:
        yield session
def get_user_by_id(user_id: str):
    # Найди пользователя по id — пример с SQLAlchemy
    return session.query(User).filter(User.id == user_id).first()

def confirm_user_in_db(user_id: str):
    user = get_user_by_id(user_id)
    if user:
        user.confirmed = True
        session.commit()

async def get_async_session():  # на случай, если будет использоваться
    async with async_session() as session:
        yield session
