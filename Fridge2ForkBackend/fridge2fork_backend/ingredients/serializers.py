# ingredients/serializers.py
from rest_framework import serializers
from .models import Ingredient

class IngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model  = Ingredient
        fields = [
            "id",
            "name",
            "category",
            "quantity",
            "unit",
            "expiration_date",
            "prioritize",
        ]
