from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
from django.contrib.auth import get_user_model
import json

User = get_user_model()

@csrf_exempt
@require_POST
def register_user(request):
    try:
        data = json.loads(request.body)
        username = data.get("username")

        print("📦 Incoming username:", username)

        if not username:
            return JsonResponse({"error": "Username required"}, status=400)

        if User.objects.filter(username=username).exists():
            return JsonResponse({"error": "Username already taken"}, status=400)

        User.objects.create_user(username=username)
        return JsonResponse({"message": "User created"}, status=201)
    except Exception as e:
        print("❌ Error:", str(e))
        return JsonResponse({"error": "Server error"}, status=500)


@csrf_exempt
@require_POST
def login_user(request):
    try:
        data = json.loads(request.body)
        username = data.get("username")
        print("🔐 Login attempt for:", username)

        if not username:
            return JsonResponse({"error": "Username is required"}, status=400)

        if User.objects.filter(username=username).exists():
            print("✅ Username exists — login allowed")
            return JsonResponse({"message": "Login successful"}, status=200)
        else:
            print("❌ Username does not exist")
            return JsonResponse({"error": "Invalid username"}, status=401)
    except Exception as e:
        print("❌ Login error:", str(e))
        return JsonResponse({"error": "Server error"}, status=500)