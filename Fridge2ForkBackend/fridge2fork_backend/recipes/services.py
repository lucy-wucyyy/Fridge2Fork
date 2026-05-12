# recipes/services.py
import requests
from datetime import datetime
from .models import Recipe, Ingredient, RecipeIngredient
import json
import logging
from django.conf import settings

logger = logging.getLogger(__name__)

MEALDB_ENDPOINT = "https://www.themealdb.com/api/json/v1/1/search.php?s={}"

def fetch_and_store_recipe(meal_name: str) -> Recipe | None:
    """
    Pull a single recipe from TheMealDB and persist it (idempotently).
    """
    resp = requests.get(MEALDB_ENDPOINT.format(meal_name))
    resp.raise_for_status()
    data = resp.json()

    meals = data.get("meals")
    if not meals:
        return None

    meal = meals[0]                                    # The first match

    # 1️⃣  Create / update the core Recipe row
    recipe, _ = Recipe.objects.update_or_create(
        external_id = meal["idMeal"],
        defaults = {
            "name":          meal["strMeal"],
            "instructions":  meal["strInstructions"] or "",
            "category":      meal["strCategory"] or "",
            "area":          meal["strArea"] or "",
            "tags":          meal["strTags"] or "",
            "thumbnail_url": meal["strMealThumb"] or "",
            "youtube_url":   meal["strYoutube"] or "",
            "source_url":    meal["strSource"] or "",
            "modified_at":   _parse_optional_date(meal["dateModified"]),
        }
    )

    # 2️⃣  Sync ingredients & measures (max 20)
    #     We wipe and recreate associations to keep it simple & consistent.
    recipe.recipe_ingredients.all().delete()

    for i in range(1, 21):
        ing_name = meal.get(f"strIngredient{i}") or ""
        measure  = (meal.get(f"strMeasure{i}") or "").strip()

        if ing_name.strip():                           # skip blanks / nulls
            ingredient, _ = Ingredient.objects.get_or_create(
                name = ing_name.strip().lower()
            )
            RecipeIngredient.objects.create(
                recipe     = recipe,
                ingredient = ingredient,
                measure    = measure
            )

    return recipe


def _parse_optional_date(date_str: str | None):
    """Convert TheMealDB's dateModified (YYYY‑MM‑DD hh:mm:ss) to datetime."""
    if not date_str:
        return None
    try:
        return datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S")
    except ValueError:
        return None
