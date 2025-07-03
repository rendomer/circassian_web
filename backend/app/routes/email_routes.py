# C:\cherkess_net\backend\app\routes\email_routes.py

from fastapi import APIRouter
from app.services.email_service import email_service
from app.schemas.email_schemas import EmailRequest

router = APIRouter(
    prefix="/email",
    tags=["email"]
)


@router.post("/send")
async def send_test_email(request: EmailRequest):
    try:
        email_service.send_email(
            request.to_email, request.subject, request.body)
        return {"message": f"Email успешно отправлен на {request.to_email}"}
    except Exception as e:
        return {"error": str(e)}
