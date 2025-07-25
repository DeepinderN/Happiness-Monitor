from django.urls import path
from .views import SubmitSurveyView, LastSurveysView, ToggleSubscriptionView,prompt_status
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('submit-survey/', SubmitSurveyView.as_view(), name='submit-survey'),
    path('last-surveys/', LastSurveysView.as_view(), name='last-surveys'),
    path('toggle-subscription/', ToggleSubscriptionView.as_view(), name='toggle-subscription'),
    path('login/', obtain_auth_token, name='login'),
    path('prompt-status/', prompt_status, name='prompt-status'),

]

