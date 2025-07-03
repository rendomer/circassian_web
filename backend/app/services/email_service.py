# app/services/email_service.py
import smtplib
import ssl
from email.message import EmailMessage
from dotenv import load_dotenv
import os

load_dotenv()

SMTP_SERVER = os.getenv("SMTP_SERVER")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_USERNAME = os.getenv("SMTP_USERNAME")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD")

if not all([SMTP_SERVER, SMTP_USERNAME, SMTP_PASSWORD]):
    raise EnvironmentError(
        "Необходимо указать SMTP_SERVER, SMTP_USERNAME и SMTP_PASSWORD в .env")


class EmailService:
    def __init__(self):
        self.smtp_server = SMTP_SERVER
        self.smtp_port = SMTP_PORT
        self.username = SMTP_USERNAME
        self.password = SMTP_PASSWORD
        self.context = ssl.create_default_context()

    def send_email(self, to_email: str, subject: str, body: str):
        msg = EmailMessage()
        msg["Subject"] = subject
        msg["From"] = self.username
        msg["To"] = to_email
        msg.set_content(body)

        with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
            server.starttls(context=self.context)
            server.login(self.username, self.password)
            server.send_message(msg)


email_service = EmailService()
