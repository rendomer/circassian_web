import json
from pathlib import Path
from app.models.user_model import User

DATA_PATH = Path("data/users.json")


def load_users() -> list[User]:
    if not DATA_PATH.exists():
        return []
    with open(DATA_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
        return [User(**u) for u in data]


def save_users(users: list[User]) -> None:
    with open(DATA_PATH, "w", encoding="utf-8") as f:
        json.dump([user.dict() for user in users],
                  f, ensure_ascii=False, indent=2)
