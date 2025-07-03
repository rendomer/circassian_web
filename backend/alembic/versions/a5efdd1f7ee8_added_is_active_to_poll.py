"""Add surveys tables and remove polls

Revision ID: a5efdd1f7ee8
Revises: 
Create Date: 2025-06-23 17:47:01.162977
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'a5efdd1f7ee8'
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Удаляем старые таблицы, если они есть
    with op.batch_alter_table('poll_options', schema=None) as batch_op:
        pass  # Таблица может отсутствовать — окей
    with op.batch_alter_table('polls', schema=None) as batch_op:
        pass  # Таблица может отсутствовать — окей

    try:
        op.drop_table('poll_options')
    except Exception:
        pass

    try:
        op.drop_table('polls')
    except Exception:
        pass

    # Поле is_active: если уже есть — ничего не делаем
    # Лучше в идеале это проверить руками в базе, но Alembic не может проверить
    # Если точно есть — закомментируем:
    # try:
    #     op.add_column('surveys', sa.Column('is_active', sa.Boolean(), server_default=sa.text("true")))
    # except Exception:
    #     pass

    # НЕ СОЗДАЁМ таблицы, которые уже есть:
    # survey_questions
    # survey_answers
    # survey_responses
    # survey_response_answers
    #
    # Они уже есть — значит пропускаем их создание.
    pass


def downgrade() -> None:
    # При откате удаляем связанные таблицы — если они существуют
    try:
        op.drop_table('survey_response_answers')
    except Exception:
        pass

    try:
        op.drop_table('survey_responses')
    except Exception:
        pass

    try:
        op.drop_table('survey_answers')
    except Exception:
        pass

    try:
        op.drop_table('survey_questions')
    except Exception:
        pass

    # Таблицу surveys не трогаем, только если её реально нужно убрать — сейчас не нужно
    # try:
    #     op.drop_table('surveys')
    # except Exception:
    #     pass

    # Возвращаем polls и poll_options
    op.create_table(
        'polls',
        sa.Column('id', sa.UUID(as_uuid=True), primary_key=True, default=sa.text("uuid_generate_v4()")),
        sa.Column('title', sa.String(200), nullable=False),
        sa.Column('question', sa.String, nullable=False),
        sa.Column('created_at', sa.DateTime(), server_default=sa.text("now()")),
        sa.Column('is_active', sa.Boolean(), server_default=sa.text("true"))
    )

    op.create_table(
        'poll_options',
        sa.Column('id', sa.UUID(as_uuid=True), primary_key=True, default=sa.text("uuid_generate_v4()")),
        sa.Column('poll_id', sa.UUID(as_uuid=True), sa.ForeignKey('polls.id', ondelete='CASCADE')),
        sa.Column('option_text', sa.String(200), nullable=False),
        sa.Column('votes', sa.Integer, server_default=sa.text("0"))
    )
