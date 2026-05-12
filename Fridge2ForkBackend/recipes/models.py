# recipes/models.py
from django.db import models
from django.conf import settings

class Ingredient(models.Model):
    """
    Canonical list of ingredients (e.g. 'garlic', 'olive oil').
    NOT tied to any single user.
    """
    name = models.CharField(max_length=200, unique=True)

    def __str__(self):
        return self.name


class Recipe(models.Model):
    """
    Mirrors almost every field TheMealDB gives us.
    """
    # Difficulty choices
    DIFFICULTY_CHOICES = [
        ('easy', 'Easy'),
        ('medium', 'Medium'),
        ('hard', 'Hard'),
    ]
    
    # Core
    external_id   = models.CharField(max_length=20, blank=True, null=True)  # idMeal (optional for user recipes)
    name          = models.CharField(max_length=200)                    # strMeal
    instructions  = models.TextField()                                  # strInstructions

    # Metadata
    category      = models.CharField(max_length=100, blank=True)        # strCategory
    area          = models.CharField(max_length=100, blank=True)        # strArea (cuisine)
    tags          = models.CharField(max_length=250, blank=True)        # strTags (comma‑sep)
    thumbnail_url = models.URLField(blank=True)                         # strMealThumb
    youtube_url   = models.URLField(blank=True)                         # strYoutube
    source_url    = models.URLField(blank=True, null=True)              # strSource
    modified_at   = models.DateTimeField(null=True, blank=True)         # dateModified
    
    # Additional fields for recipe filtering
    cook_time     = models.IntegerField(null=True, blank=True)          # cooking time in minutes
    difficulty    = models.CharField(max_length=10, choices=DIFFICULTY_CHOICES, blank=True)
    kitchen_tools = models.CharField(max_length=250, blank=True)        # comma-separated list of tools

    # Optional user‑centric fields
    creator = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        null=True, blank=True,
        on_delete=models.SET_NULL,
        related_name='created_recipes'
    )
    favorited_by = models.ManyToManyField(
        settings.AUTH_USER_MODEL,
        blank=True,
        related_name='favorite_recipes'
    )

    def __str__(self):
        return self.name


class RecipeIngredient(models.Model):
    """
    Join table that stores the *measure text* exactly the way we get it
    ('1/4 cup', '3 cloves', …).
    """
    recipe     = models.ForeignKey(Recipe, on_delete=models.CASCADE, related_name='recipe_ingredients')
    ingredient = models.ForeignKey(Ingredient, on_delete=models.CASCADE, related_name='ingredient_recipes')
    measure    = models.CharField(max_length=100, blank=True)           # strMeasureN

    class Meta:
        unique_together = ('recipe', 'ingredient')

    def __str__(self):
        return f"{self.measure} {self.ingredient.name} for {self.recipe.name}"