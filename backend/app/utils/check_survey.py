import asyncio
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, selectinload
from sqlalchemy.future import select
from app.models.survey_model import Survey, SurveyQuestion, SurveyAnswer

DATABASE_URL = "postgresql+asyncpg://user:password@localhost/dbname"

engine = create_async_engine(DATABASE_URL, echo=False)
SessionLocal = sessionmaker(engine, expire_on_commit=False, class_=AsyncSession)

async def check_survey():
    async with SessionLocal() as session:
        result = await session.execute(
            select(Survey).where(Survey.is_active == True)
            .options(selectinload(Survey.questions).selectinload(SurveyQuestion.answers))
        )
        survey = result.scalars().first()

        if not survey:
            print("Нет активного опроса.")
            return

        print(f"Опрос: {survey.title}")
        print(f"Описание: {survey.description}\n")

        for q in survey.questions:
            print(f"Вопрос: {q.question_text}")
            for a in q.answers:
                print(f" - {a.answer_text}")
            print()

if __name__ == "__main__":
    asyncio.run(check_survey())
