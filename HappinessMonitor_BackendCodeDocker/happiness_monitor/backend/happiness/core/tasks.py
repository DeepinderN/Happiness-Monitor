from celery import shared_task
from .notifications import get_users_to_notify

@shared_task
def send_survey_prompts():
    users = get_users_to_notify()
    for user in users:
        # Replace with APNs integration in production
        print(f"[Celery] Prompt sent to: {user.username}")
