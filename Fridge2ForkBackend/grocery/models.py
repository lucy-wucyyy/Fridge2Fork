from django.db import models
from django.conf import settings

class GroceryItem(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='grocery_items'
    )
    name = models.CharField(max_length=200)
    quantity = models.FloatField(default=1)
    unit = models.CharField(max_length=50, default='units')
    is_purchased = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.name} - {self.quantity} {self.unit}"
