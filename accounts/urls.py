from django.contrib.auth.views import LoginView, LogoutView
from django.urls import path
from {PROJECT}.accounts import views as v

urlpatterns = [
    path(
        'login/',
        LoginView.as_view(template_name='accounts/login.html'),
        name='login'
    ),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('signup/', v.SignUpView.as_view(), name='signup'),
]
