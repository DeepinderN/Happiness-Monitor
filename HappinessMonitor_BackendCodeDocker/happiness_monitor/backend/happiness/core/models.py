from django.db import models
from django.contrib.auth.models import User

class Survey(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    activity = models.CharField(max_length=255)
    happiness_level = models.IntegerField()  # from 1 to 10, for example
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.timestamp} - {self.happiness_level}"

# class Subscription(models.Model):
#     user = models.OneToOneField(User, on_delete=models.CASCADE)
#     is_subscribed = models.BooleanField(default=False)
#     last_prompt_sent = models.DateTimeField(null=True, blank=True)

#     def __str__(self):
#         return f"{self.user.username} - {'Subscribed' if self.is_subscribed else 'Unsubscribed'}"

class Subscription(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    is_subscribed = models.BooleanField(default=False)
    last_prompt_sent = models.DateTimeField(null=True, blank=True)
    last_survey_time = models.DateTimeField(null=True, blank=True)  # NEW

    def __str__(self):
        return f"{self.user.username} - {'Subscribed' if self.is_subscribed else 'Unsubscribed'}"
