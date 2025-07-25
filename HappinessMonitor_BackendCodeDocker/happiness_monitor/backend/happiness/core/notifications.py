from django.utils import timezone
from .models import Subscription
from datetime import timedelta

def get_users_to_notify():
    now = timezone.now()
    notify_list = []

    for sub in Subscription.objects.filter(is_subscribed=True):
        last_prompt = sub.last_prompt_sent or now - timedelta(minutes=2)
        last_survey = sub.last_survey_time or now - timedelta(minutes=5)

        # Check if 1 minute passed since last prompt
        if (now - last_prompt).total_seconds() >= 60:
            # But only if more than 2 minutes passed since last survey
            if (now - last_survey).total_seconds() >= 120:
                notify_list.append(sub.user)
                sub.last_prompt_sent = now
                sub.save()

    return notify_list
