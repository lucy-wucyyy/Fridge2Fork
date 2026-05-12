from django.shortcuts import render
from .models import Recipe

def recipe_list(request):
    recipes = Recipe.objects.all()

    cook_time_filter = request.GET.get('cook_time')  # e.g. 30 for "30 minutes or less"
    difficulty_filter = request.GET.get('difficulty')  # e.g. "easy"
    tool_filter = request.GET.get('tool')  # e.g. "air fryer"

    if cook_time_filter:
        recipes = recipes.filter(cook_time__lte=int(cook_time_filter))
    if difficulty_filter:
        recipes = recipes.filter(difficulty=difficulty_filter)
    if tool_filter:
        recipes = recipes.filter(kitchen_tools__icontains=tool_filter)

    return render(request, 'recipes/recipe_list.html', {'recipes': recipes})
