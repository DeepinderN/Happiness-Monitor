FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

# RUN chmod +x /app/entrypoint.sh
# ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]


CMD ["python","happiness/manage.py", "runserver", "0.0.0.0:8000"]