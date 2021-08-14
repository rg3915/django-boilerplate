from django.shortcuts import render
from django.views.decorators.http import require_http_methods
from django.views.generic import ListView

from .forms import ExpenseForm
from .mixins import SearchExpenseMixin
from .models import Expense


class ExpenseListView(SearchExpenseMixin, ListView):
    model = Expense
    paginate_by = 10


def expense_detail(request, pk):
    template_name = 'expense/expense_detail.html'
    obj = Expense.objects.get(pk=pk)
    context = {'object': obj}
    return render(request, template_name, context)


def expense_create(request):
    template_name = 'expense/expense_form.html'
    form = ExpenseForm(request.POST or None)

    if request.method == 'POST':
        if form.is_valid():
            expense = form.save()
            template_name = 'expense/expense_result.html'
            context = {'object': expense}
            return render(request, template_name, context)

    context = {'form': form}
    return render(request, template_name, context)


def expense_update(request, pk):
    template_name = 'expense/expense_update_form.html'
    instance = Expense.objects.get(pk=pk)
    form = ExpenseForm(request.POST or None, instance=instance)

    if request.method == 'POST':
        if form.is_valid():
            expense = form.save()
            template_name = 'expense/expense_result.html'
            context = {'object': expense}
            return render(request, template_name, context)

    context = {'form': form, 'object': instance}
    return render(request, template_name, context)


@require_http_methods(['DELETE'])
def expense_delete(request, pk):
    obj = Expense.objects.get(pk=pk)
    obj.delete()
    return render(request, 'expense/expense_table.html')
