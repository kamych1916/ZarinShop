import smtplib
from email.mime.text import MIMEText
from email.header import Header
from config import email

async def send_mes(user_email: str, text: str):
    server = smtplib.SMTP_SSL('smtp.mail.ru', 465)
    server.login(email.Config.LOGIN_EMAIL, email.Config.PASSWORD_EMAIL)
    msg = MIMEText(text, 'plain', 'utf-8')
    msg['Subject'] = Header('Подтверждение действий', 'utf-8')
    msg['From'] = email.Config.LOGIN_EMAIL
    msg['To'] = user_email
    server.sendmail(email.Config.LOGIN_EMAIL, user_email, msg.as_string())
    server.quit()

