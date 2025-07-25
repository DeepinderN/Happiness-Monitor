#!/bin/bash

# Wait for DB to be ready (optional, for safety)
sleep 5

# Run migrations
python happiness/manage.py migrate --noinput

# Create default user and token (only if not exist)
python happiness/manage.py shell << EOF
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token

u, created = User.objects.get_or_create(username="defaultuser")
if created:
    u.set_password("defaultpass")
    u.is_staff = True
    u.is_superuser = True
    u.save()
Token.objects.get_or_create(user=u)

EOF

# Start the dev server
exec python happiness/manage.py runserver 0.0.0.0:8000
