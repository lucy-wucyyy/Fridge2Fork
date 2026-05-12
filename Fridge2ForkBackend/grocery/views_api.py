# grocery/views_api.py
from rest_framework import viewsets, permissions, filters, status
from rest_framework.decorators import action
from rest_framework.response import Response

from django.db import transaction
from ingredients.models import Ingredient
from ingredients.serializers import IngredientSerializer

from .models import GroceryItem
from .serializers import GroceryItemSerializer

class GroceryItemViewSet(viewsets.ModelViewSet):
    """
    CRUD on the logged-in user's grocery list.
    """
    serializer_class = GroceryItemSerializer
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ["name"]
    ordering_fields = ["name"]

    def get_queryset(self):
        return (
            GroceryItem.objects
            .filter(user=self.request.user)
            .order_by("name")
        )

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
        
    @action(detail=False, methods=["post"])
    def add_to_fridge(self, request):
        """
        Transfer purchased grocery items to the fridge
        POST /api/grocery-items/add_to_fridge/
        
        Optional query parameters:
        - purchased_only: If true, only transfer purchased items (default: true)
        - remove_after_transfer: If true, remove items from grocery list after transfer (default: true)
        """
        purchased_only = request.query_params.get('purchased_only', 'true').lower() == 'true'
        remove_after = request.query_params.get('remove_after_transfer', 'true').lower() == 'true'
        
        # Get grocery items, filter by purchased if needed
        queryset = self.get_queryset()
        if purchased_only:
            queryset = queryset.filter(is_purchased=True)
            
        # If no items to transfer
        if not queryset.exists():
            return Response(
                {"detail": "No grocery items to transfer to fridge."}, 
                status=status.HTTP_400_BAD_REQUEST
            )
            
        # Transfer items to fridge
        transferred_items = []
        
        with transaction.atomic():
            for grocery_item in queryset:
                # Create fridge item with same properties
                ingredient = Ingredient.objects.create(
                    user=request.user,
                    name=grocery_item.name,
                    quantity=grocery_item.quantity,
                    unit=grocery_item.unit,
                    category='other',  # Default category
                    prioritize=False,
                )
                
                # Optionally remove from grocery list
                if remove_after:
                    grocery_item.delete()
                # Otherwise mark as purchased
                elif not grocery_item.is_purchased:
                    grocery_item.is_purchased = True
                    grocery_item.save()
                    
                transferred_items.append(ingredient)
        
        # Return the newly created fridge items
        if transferred_items:
            serializer = IngredientSerializer(transferred_items, many=True)
            return Response({
                "detail": f"Successfully transferred {len(transferred_items)} items to fridge.",
                "transferred_items": serializer.data
            })
        else:
            return Response({"detail": "No items were transferred."}, status=status.HTTP_400_BAD_REQUEST) 