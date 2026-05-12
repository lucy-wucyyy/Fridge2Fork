from django.contrib.auth import get_user_model
from rest_framework.test import APITestCase
from rest_framework import status
from .models import Ingredient

User = get_user_model()

class PantryAPITest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(username="alice", password="secret")
        self.client.login(username="alice", password="secret")

    def test_create_and_list_ingredient(self):
        # initially empty
        resp = self.client.get("/api/pantry-items/")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        self.assertEqual(resp.data, [])

        # create one
        payload = {
            "name": "tomato",
            "category": "vegetable",
            "quantity": 3,
            "unit": "pieces"
        }
        resp = self.client.post("/api/pantry-items/", payload, format="json")
        self.assertEqual(resp.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Ingredient.objects.count(), 1)
        self.assertEqual(Ingredient.objects.first().name, "tomato")

        # list now returns one
        resp = self.client.get("/api/pantry-items/")
        self.assertEqual(len(resp.data), 1)

    def test_prioritized_filter(self):
        # create two items, one prioritized
        i1 = Ingredient.objects.create(user=self.user, name="a", category="x", quantity=1, unit="u", prioritize=False)
        i2 = Ingredient.objects.create(user=self.user, name="b", category="y", quantity=1, unit="u", prioritize=True)

        resp = self.client.get("/api/pantry-items/prioritized/")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        names = [item["name"] for item in resp.data]
        self.assertListEqual(names, ["b"])
