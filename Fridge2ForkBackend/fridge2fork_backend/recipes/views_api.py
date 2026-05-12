from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from .models import Recipe, Ingredient
from .serializers import RecipeSerializer, RecipeDetailSerializer

class RecipeViewSet(viewsets.ModelViewSet):
    """
    API endpoints for recipes
    """
    serializer_class = RecipeSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = {
        "category": ["exact", "icontains"],
        "area": ["exact", "icontains"],
        "difficulty": ["exact"],
        "cook_time": ["lte", "gte"],
        "tags": ["icontains"],
        "kitchen_tools": ["icontains"],
        "favorited_by": ["exact"],
    }

    def get_queryset(self):
        queryset = Recipe.objects.all()
        
        # Handle ingredients filtering
        ingredients = self.request.query_params.get('ingredients', None)
        match_type = self.request.query_params.get('match', 'any')
        
        if ingredients:
            ingredient_list = [i.strip() for i in ingredients.split(',')]
            
            if match_type == 'all':
                # Recipe must have ALL ingredients
                for ingredient in ingredient_list:
                    queryset = queryset.filter(
                        recipe_ingredients__ingredient__name__icontains=ingredient
                    )
            else:
                # Recipe must have ANY of the ingredients
                queryset = queryset.filter(
                    recipe_ingredients__ingredient__name__icontains=ingredient_list[0]
                )
                for ingredient in ingredient_list[1:]:
                    queryset = queryset.union(
                        Recipe.objects.filter(
                            recipe_ingredients__ingredient__name__icontains=ingredient
                        )
                    )
                    
        return queryset.distinct()

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return RecipeDetailSerializer
        return RecipeSerializer

    def perform_create(self, serializer):
        serializer.save(creator=self.request.user)

    def update(self, request, *args, **kwargs):
        recipe = self.get_object()
        # Only allow creators to update their recipes
        if recipe.creator != request.user:
            return Response(
                {"detail": "You can only edit your own recipes."}, 
                status=status.HTTP_403_FORBIDDEN
            )
        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        recipe = self.get_object()
        # Only allow creators to delete their recipes
        if recipe.creator != request.user:
            return Response(
                {"detail": "You can only delete your own recipes."}, 
                status=status.HTTP_403_FORBIDDEN
            )
        return super().destroy(request, *args, **kwargs)

    @action(detail=True, methods=["post"])
    def favorite(self, request, pk=None):
        recipe = self.get_object()
        recipe.favorited_by.add(request.user)
        return Response({"status": "recipe favorited"})

    @action(detail=True, methods=["post"])
    def unfavorite(self, request, pk=None):
        recipe = self.get_object()
        recipe.favorited_by.remove(request.user)
        return Response({"status": "recipe unfavorited"})
        
    @action(detail=False, methods=["get"])
    def search_by_ingredients(self, request):
        """
        Search recipes by ingredients
        GET /api/recipes/search-by-ingredients/?ingredients=ing1,ing2&match=all
        """
        ingredients = request.query_params.get('ingredients', None)
        if not ingredients:
            return Response(
                {"detail": "Please provide ingredients parameter"}, 
                status=status.HTTP_400_BAD_REQUEST
            )
            
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)
