from django.db import models
from django.conf import settings

class Ingredient(models.Model):
    CATEGORY_CHOICES = [
        ('protein', 'Protein'),
        ('carb', 'Carbohydrate'),
        ('vegetable', 'Vegetable'),
        ('fruit', 'Fruit'),
        ('dairy', 'Dairy'),
        # etc...
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='ingredients'
    )
    name = models.CharField(max_length=200)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    quantity = models.FloatField(default=1)
    unit = models.CharField(max_length=50, default='units')  # e.g., "cups", "lbs", "pieces"
    expiration_date = models.DateField(null=True, blank=True)
    prioritize = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.name} ({self.category})"
