import os
from celery import Celery

# Set default Django settings module for Celery
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'happiness.settings')

app = Celery('happiness')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
