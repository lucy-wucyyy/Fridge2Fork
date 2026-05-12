# Create your models here.
from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    # Can add extra fields
    favorite_cuisine = models.CharField(max_length=100, blank=True, null=True)
    
    def __str__(self):
        return self.username
