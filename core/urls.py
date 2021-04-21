from django.urls import path

from {PROJECT}.core import views as v

app_name = 'core'


urlpatterns = [
    path('', v.index, name='index'),
]
