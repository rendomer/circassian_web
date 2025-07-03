# 📂 app/models/survey_model.py

from sqlalchemy import Column, String, ForeignKey, Text, Boolean, TIMESTAMP, Integer
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid

from app.database import Base


class Survey(Base):
    __tablename__ = "surveys"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())

    questions = relationship("SurveyQuestion", back_populates="survey", cascade="all, delete")


class SurveyQuestion(Base):
    __tablename__ = "survey_questions"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    survey_id = Column(UUID(as_uuid=True), ForeignKey("surveys.id", ondelete="CASCADE"))
    question_text = Column(Text, nullable=False)

    survey = relationship("Survey", back_populates="questions")
    answers = relationship("SurveyAnswer", back_populates="question", cascade="all, delete")


class SurveyAnswer(Base):
    __tablename__ = "survey_answers"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    question_id = Column(UUID(as_uuid=True), ForeignKey("survey_questions.id", ondelete="CASCADE"))
    answer_text = Column(Text, nullable=False)
    votes = Column(Integer, default=0)

    question = relationship("SurveyQuestion", back_populates="answers")


class SurveyResponse(Base):
    __tablename__ = "survey_responses"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    survey_id = Column(UUID(as_uuid=True), ForeignKey("surveys.id", ondelete="CASCADE"))
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    survey = relationship('Survey')
    submitted_at = Column(TIMESTAMP, server_default=func.now())


class SurveyResponseAnswer(Base):
    __tablename__ = "survey_response_answers"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    response_id = Column(UUID(as_uuid=True), ForeignKey("survey_responses.id", ondelete="CASCADE"))
    question_id = Column(UUID(as_uuid=True), ForeignKey("survey_questions.id", ondelete="CASCADE"))
    answer_id = Column(UUID(as_uuid=True), ForeignKey("survey_answers.id", ondelete="CASCADE"))
