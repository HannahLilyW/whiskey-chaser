from django.urls import include, path
from rest_framework import routers
from whiskey_api import views
from whiskey.obtain_expiring_auth_token import ObtainExpiringAuthToken


router = routers.DefaultRouter()

urlpatterns = [
    path('', include(router.urls)),
]
