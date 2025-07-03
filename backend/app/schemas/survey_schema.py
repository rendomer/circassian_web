# 📂 app/models/survey_schema.py

from pydantic import BaseModel
from typing import List, Dict, Any
from uuid import UUID


class SurveyAnswerOut(BaseModel):
    id: UUID
    answer_text: str

class SurveyQuestionOut(BaseModel):
    id: UUID
    question_text: str
    answers: List[SurveyAnswerOut]

class SurveyOut(BaseModel):
    id: UUID
    title: str
    description: str
    questions: List[SurveyQuestionOut]

class VoteSubmission(BaseModel):
    user_id: UUID
    answers: Dict[UUID, UUID]  # {question_id: answer_id}

class SurveyResultsOut(BaseModel):
    survey_title: str
    results: List[Dict[str, Any]]
