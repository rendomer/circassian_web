from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from fastapi import HTTPException
from app.schemas.survey_schema import SurveyOut, SurveyQuestionOut, SurveyAnswerOut
from app.models.survey_model import Survey, SurveyResponse, SurveyResponseAnswer, SurveyQuestion, SurveyAnswer
import uuid


async def get_active_survey_service(db: AsyncSession) -> SurveyOut:
    result = await db.execute(
        select(Survey)
        .where(Survey.is_active == True)
        .options(
            selectinload(Survey.questions).selectinload(SurveyQuestion.answers)
        )
    )
    survey = result.scalars().first()
    if not survey:
        raise HTTPException(status_code=404, detail="Нет активного опроса")

    return SurveyOut(
        id=survey.id,
        title=survey.title,
        description=survey.description,
        questions=[
            SurveyQuestionOut(
                id=q.id,
                question_text=q.question_text,
                answers=[
                    SurveyAnswerOut(id=a.id, answer_text=a.answer_text)
                    for a in q.answers
                ]
            )
            for q in survey.questions
        ]
    )


async def vote_in_survey_service(survey_id: uuid.UUID, user_id: uuid.UUID, answers: dict, db: AsyncSession):
    result = await db.execute(
        select(Survey)
        .where(Survey.id == survey_id)
        .options(
            selectinload(Survey.questions).selectinload(SurveyQuestion.answers)
        )
    )
    survey = result.scalars().first()
    if not survey:
        raise HTTPException(status_code=404, detail="Опрос не найден")

    response = SurveyResponse(survey_id=survey_id, user_id=user_id)
    db.add(response)
    await db.flush()

    for question_id, answer_id in answers.items():
        # Проверяем типы и создаём UUID только если нужно
        q_id = question_id if isinstance(question_id, uuid.UUID) else uuid.UUID(question_id)
        a_id = answer_id if isinstance(answer_id, uuid.UUID) else uuid.UUID(answer_id)

        db.add(SurveyResponseAnswer(
            response_id=response.id,
            question_id=q_id,
            answer_id=a_id
        ))

        await db.execute(
            SurveyAnswer.__table__.update()
            .where(SurveyAnswer.id == a_id)
            .values(votes=SurveyAnswer.votes + 1)
        )

    await db.commit()
    return {"message": "Ответ сохранен"}


async def get_survey_results_service(survey_id: uuid.UUID, db: AsyncSession):
    result = await db.execute(
        select(Survey)
        .where(Survey.id == survey_id)
        .options(
            selectinload(Survey.questions).selectinload(SurveyQuestion.answers)
        )
    )
    survey = result.scalars().first()
    if not survey:
        raise HTTPException(status_code=404, detail="Опрос не найден")

    data = []
    for q in survey.questions:
        answers_data = []
        for a in q.answers:
            answers_data.append({"answer": a.answer_text, "count": a.votes})

        data.append({
            "question": q.question_text,
            "answers": answers_data
        })

    return {
        "survey_title": survey.title,
        "results": data
    }
