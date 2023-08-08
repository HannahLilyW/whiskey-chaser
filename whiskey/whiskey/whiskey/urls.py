from django.urls import include, path
from rest_framework import routers
from whiskey_api import views
from whiskey.obtain_expiring_auth_token import ObtainExpiringAuthToken


router = routers.DefaultRouter()

urlpatterns = [
    path('create_account/', views.CreateAccountView.as_view()),
    path('login/', ObtainExpiringAuthToken.as_view()),
    path('logout/', views.LogOutView.as_view()),
    path('', include(router.urls)),
]
