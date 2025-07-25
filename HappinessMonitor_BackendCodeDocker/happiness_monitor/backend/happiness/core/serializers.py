from rest_framework import serializers
from .models import Survey, Subscription

class SurveySerializer(serializers.ModelSerializer):
    class Meta:
        model = Survey
        fields = ['id', 'activity', 'happiness_level', 'timestamp']

class CreateSurveySerializer(serializers.ModelSerializer):
    class Meta:
        model = Survey
        fields = ['activity', 'happiness_level']

class SubscriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Subscription
        fields = ['is_subscribed']
