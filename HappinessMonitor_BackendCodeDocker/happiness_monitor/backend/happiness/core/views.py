from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Survey, Subscription
from .serializers import SurveySerializer, CreateSurveySerializer, SubscriptionSerializer
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.authtoken.views import obtain_auth_token
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.utils import timezone
from datetime import timedelta
from .models import Subscription


class SubmitSurveyView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        serializer = CreateSurveySerializer(data=request.data)
        if serializer.is_valid():
            survey = serializer.save(user=request.user)

            # Update last_survey_time
            sub, _ = Subscription.objects.get_or_create(user=request.user)
            sub.last_survey_time = survey.timestamp
            sub.save()

            return Response({"message": "Survey saved."}, status=201)
        return Response(serializer.errors, status=400)


class LastSurveysView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = SurveySerializer

    def get_queryset(self):
        return Survey.objects.filter(user=self.request.user).order_by('-timestamp')[:3]

class ToggleSubscriptionView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        sub, _ = Subscription.objects.get_or_create(user=request.user)
        sub.is_subscribed = not sub.is_subscribed
        sub.save()
        return Response({'is_subscribed': sub.is_subscribed})

def get(self, request):
    sub, _ = Subscription.objects.get_or_create(user=request.user)
    return Response({'is_subscribed': sub.is_subscribed})


@api_view(['GET'])
def prompt_status(request):
    try:
        sub = Subscription.objects.get(user=request.user)
    except Subscription.DoesNotExist:
        return Response({"show_prompt": False})

    now = timezone.now()

    # Default old timestamps if null
    last_prompt = sub.last_prompt_sent or (now - timedelta(minutes=5))
    last_survey = sub.last_survey_time or (now - timedelta(minutes=5))

    should_prompt = (
        sub.is_subscribed and
        (now - last_prompt).total_seconds() >= 60 and
        (now - last_survey).total_seconds() >= 120
    )

    return Response({"show_prompt": should_prompt})
