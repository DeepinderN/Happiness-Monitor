from django.core.management.base import BaseCommand
from core.notifications import get_users_to_notify

class Command(BaseCommand):
    help = "Simulate sending notifications"

    def handle(self, *args, **kwargs):
        users = get_users_to_notify()
        for user in users:
            self.stdout.write(self.style.SUCCESS(f"Notification sent to: {user.username}"))
