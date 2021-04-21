from django.contrib import admin

from .models import Person


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'email', 'active')
    # readonly_fields = ('slug',)
    # list_display_links = ('name',)
    search_fields = ('first_name', 'last_name', 'email')
    list_filter = ('active',)
    # date_hierarchy = 'created'
    # ordering = ('-created',)
    # actions = ('',)
