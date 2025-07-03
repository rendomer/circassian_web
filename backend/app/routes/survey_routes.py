# 📂 app/routes/survey_routes.py

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from uuid import UUID

from app.database import get_db
from app.services.survey_service import (
    get_active_survey_service,
    vote_in_survey_service,
    get_survey_results_service,
)
from app.schemas.survey_schema import VoteSubmission, SurveyOut, SurveyResultsOut
from app.models.survey_model import Survey

router = APIRouter(tags=["surveys"])


@router.get("/active", response_model=SurveyOut)
async def get_active_survey(db: AsyncSession = Depends(get_db)):
    return await get_active_survey_service(db)


@router.post("/{survey_id}/vote")
async def vote_in_survey(survey_id: UUID, vote_data: VoteSubmission, db: AsyncSession = Depends(get_db)):
    return await vote_in_survey_service(survey_id, vote_data.user_id, vote_data.answers, db)


@router.get("/{survey_id}/results", response_model=SurveyResultsOut)
async def get_survey_results(survey_id: UUID, db: AsyncSession = Depends(get_db)):
    return await get_survey_results_service(survey_id, db)

@router.get("/archive")
async def get_survey_archive(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Survey).where(Survey.is_active == False))
    surveys = result.scalars().all()
    return [
        {
            "id": str(survey.id),
            "question": survey.question,
            "created_at": str(survey.created_at)
        }
        for survey in surveys
    ]