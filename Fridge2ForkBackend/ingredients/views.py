from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from .models import Ingredient

@login_required
def list_ingredients(request):
    user_ingredients = Ingredient.objects.filter(user=request.user)
    return render(request, 'ingredients/list.html', {'ingredients': user_ingredients})

@login_required
def add_ingredient(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        category = request.POST.get('category')
        expiration_date = request.POST.get('expiration_date')
        quantity = request.POST.get('quantity', 1)
        unit = request.POST.get('unit', 'units')
        prioritize = 'prioritize' in request.POST

        Ingredient.objects.create(
            user=request.user,
            name=name,
            category=category,
            expiration_date=expiration_date or None,
            quantity=quantity,
            unit=unit,
            prioritize=prioritize
        )
        return redirect('list_ingredients')

    return render(request, 'ingredients/add.html')
