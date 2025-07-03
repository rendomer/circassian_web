#scripts/init_db.py
import os
import sys
import asyncio

# Добавляем путь backend/ в PYTHONPATH
current_dir = os.path.dirname(__file__)
backend_dir = os.path.abspath(os.path.join(current_dir, ".."))
sys.path.insert(0, backend_dir)

import app.models.user_model  # подтягиваем модели
from app.database import init_models

if __name__ == "__main__":
    print("🛠️  Initializing database models...")
    asyncio.run(init_models())
    print("✅  Database initialized successfully.")

