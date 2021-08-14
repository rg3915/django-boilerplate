from django.db.models import Q


class SearchExpenseMixin:

    def get_queryset(self):
        queryset = super(SearchExpenseMixin, self).get_queryset()
        search = self.request.GET.get('search')
        if search:
            return queryset.filter(
                Q(person__first_name__icontains=search) |
                Q(person__last_name__icontains=search) |
                Q(person__email__icontains=search) |
                Q(description__icontains=search)
            )
        return queryset
