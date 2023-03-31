from django.db import models
from django.urls import reverse_lazy
from {PROJECT}.core.models import Active, Address, Document, TimeStampedModel


class Person(TimeStampedModel, Address, Document, Active):
    first_name = models.CharField('nome', max_length=50)
    last_name = models.CharField('sobrenome', max_length=50, null=True, blank=True)  # noqa E501
    email = models.EmailField(null=True, blank=True)

    class Meta:
        ordering = ('first_name',)
        verbose_name = 'pessoa'
        verbose_name_plural = 'pessoas'

    @property
    def full_name(self):
        return f'{self.first_name} {self.last_name or ""}'.strip()

    def __str__(self):
        return self.full_name

    def get_absolute_url(self):
        return reverse_lazy('crm:person_detail', kwargs={'pk': self.pk})

    def get_fields_verbose_names(self):
        return [{'name': field.verbose_name, 'value': getattr(self, field.name)} for field in self._meta.fields]
