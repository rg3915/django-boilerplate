from django.urls import path
from {PROJECT}.expense import views as v

app_name = 'expense'


urlpatterns = [
    path('', v.ExpenseListView.as_view(), name='expense_list'),
    path('<int:pk>/', v.expense_detail, name='expense_detail'),
    path('create/', v.expense_create, name='expense_create'),
    path('<int:pk>/update/', v.expense_update, name='expense_update'),
    path('<int:pk>/delete/', v.expense_delete, name='expense_delete'),
]
