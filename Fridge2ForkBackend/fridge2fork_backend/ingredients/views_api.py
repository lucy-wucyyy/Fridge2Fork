# ingredients/views_api.py
from datetime import timedelta
from django.utils import timezone
from rest_framework import viewsets, permissions, filters
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Ingredient
from .serializers import IngredientSerializer

class FridgeItemViewSet(viewsets.ModelViewSet):
    """
    CRUD on the logged-in user's Ingredient (their fridge).
    """
    serializer_class   = IngredientSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends    = [filters.SearchFilter, filters.OrderingFilter]
    search_fields      = ["name", "category"]
    ordering_fields    = ["expiration_date", "name", "category"]

    def get_queryset(self):
        return (
            Ingredient.objects
            .filter(user=self.request.user)
            .order_by("expiration_date", "name")
        )

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=False, methods=["get"])
    def prioritized(self, request):
        qs   = self.get_queryset().filter(prioritize=True)
        data = self.get_serializer(qs, many=True).data
        return Response(data)

    @action(detail=False, methods=["get"])
    def expiring(self, request):
        days       = int(request.query_params.get("days", 3))
        today      = timezone.now().date()
        window_end = today + timedelta(days=days)
        qs         = self.get_queryset().filter(
            expiration_date__range=[today, window_end]
        )
        data       = self.get_serializer(qs, many=True).data
        return Response(data)