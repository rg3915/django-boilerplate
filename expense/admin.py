from django.contrib import admin

from .models import Expense


@admin.register(Expense)
class ExpenseAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'person', 'value', 'payment_date', 'paid')
    search_fields = ('description', 'person__first_name', 'person__last_name')
    list_filter = ('paid',)
    date_hierarchy = 'payment_date'
