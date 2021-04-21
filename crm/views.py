from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.views.generic import (
    CreateView,
    DeleteView,
    DetailView,
    ListView,
    UpdateView
)

from .forms import PersonForm
from .models import Person


def person_list(request):
    template_name = 'person/person_list.html'
    object_list = Person.objects.all()
    context = {'object_list': object_list}
    return render(request, template_name, context)


def person_detail(request, pk):
    template_name = 'person/person_detail.html'
    obj = Person.objects.get(pk=pk)
    context = {'object': obj}
    return render(request, template_name, context)


def person_create(request):
    template_name = 'person/person_form.html'
    form = PersonForm(request.POST or None)

    if request.method == 'POST':
        if form.is_valid():
            form.save()
            return redirect('person:person_list')

    context = {'form': form}
    return render(request, template_name, context)


def person_update(request, pk):
    template_name = 'person/person_form.html'
    instance = Person.objects.get(pk=pk)
    form = PersonForm(request.POST or None, instance=instance)

    if request.method == 'POST':
        if form.is_valid():
            form.save()
            return redirect('person:person_list')

    context = {'form': form}
    return render(request, template_name, context)


def person_delete(request, pk):
    template_name = 'person/person_confirm_delete.html'
    obj = Person.objects.get(pk=pk)

    if request.method == 'POST':
        obj.delete()
        return redirect('person:person_list')

    context = {'object': obj}
    return render(request, template_name, context)


class PersonListView(ListView):
    model = Person


class PersonDetailView(DetailView):
    model = Person


class PersonCreateView(CreateView):
    model = Person
    form_class = PersonForm


class PersonUpdateView(UpdateView):
    model = Person
    form_class = PersonForm


class PersonDeleteView(DeleteView):
    model = Person
    success_url = reverse_lazy('person:person_list')
