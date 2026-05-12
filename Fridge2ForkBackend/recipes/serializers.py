from rest_framework import serializers
from .models import Recipe, RecipeIngredient, Ingredient

class IngredientSerializer(serializers.ModelSerializer):
    class Meta:
        model  = Ingredient
        fields = ("id", "name")

class RecipeIngredientSerializer(serializers.ModelSerializer):
    ingredient = IngredientSerializer()

    class Meta:
        model  = RecipeIngredient
        fields = ("ingredient", "amount")

class RecipeSerializer(serializers.ModelSerializer):
    ingredients = RecipeIngredientSerializer(
        source="recipe_ingredients", many=True, read_only=True
    )
    is_favorite = serializers.SerializerMethodField()

    class Meta:
        model  = Recipe
        fields = (
            "id",
            "name",
            "time",
            "image",
            "difficulty",
            "calories",
            "ingredients",
            "amounts",
            "steps",
            "is_favorite",

            # not included in the front end
            "external_id",
            "category",
            "area",
            "tags",
            "thumbnail_url",
            "youtube_url",
            "source_url",
            "kitchen_tools",
        )

    def get_is_favorite(self, obj):
        user = self.context["request"].user
        return user.is_authenticated and obj.favorited_by.filter(id=user.id).exists()
    
class RecipeDetailSerializer(RecipeSerializer):
    """
    Detailed recipe serializer with additional fields
    """
    creator_username = serializers.SerializerMethodField()
    favorited_by = serializers.SerializerMethodField()
    
    class Meta(RecipeSerializer.Meta):
        fields = RecipeSerializer.Meta.fields + (
            "creator_username",
            "favorited_by",
        )
    
    def get_creator_username(self, obj):
        if obj.creator:
            return obj.creator.username
        return None
    
    def get_favorited_by(self, obj):
        return list(obj.favorited_by.values_list('id', flat=True))