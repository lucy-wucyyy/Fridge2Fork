# fridge2fork_backend/urls.py
from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from ingredients.views_api import PantryItemViewSet

router = DefaultRouter()
router.register(r"pantry-items", PantryItemViewSet, basename="pantryitem")

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include(router.urls)),
    path("accounts/", include("allauth.urls")),
]
