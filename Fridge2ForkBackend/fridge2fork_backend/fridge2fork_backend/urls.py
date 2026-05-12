from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter

from ingredients.views_api import FridgeItemViewSet
from grocery.views_api import GroceryItemViewSet
from recipes.views_api import RecipeViewSet
from users.views import register_user, login_user

router = DefaultRouter()
router.register(r"fridge-items", FridgeItemViewSet, basename="fridgeitem")
router.register(r"grocery-items", GroceryItemViewSet, basename="groceryitem")
router.register(r"recipes", RecipeViewSet, basename="recipe")

urlpatterns = [
    path("admin/",  admin.site.urls),
    path("api/",    include(router.urls)),              # DRF endpoints
    path("accounts/", include("allauth.urls")),         # auth routes
    path('api/signup/', register_user),
    path("api/login/", login_user),
]

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns += [
    path("api/token/",   TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
]
