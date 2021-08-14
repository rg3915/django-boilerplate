from django.db import models
from django.urls import reverse_lazy
from {PROJECT}.core.models import TimeStampedModel
from {PROJECT}.crm.models import Person


class Expense(TimeStampedModel):
    description = models.CharField('descrição', max_length=50)
    payment_date = models.DateField('data de pagamento', null=True, blank=True)
    person = models.ForeignKey(
        Person,
        on_delete=models.SET_NULL,
        verbose_name='pago a',
        related_name='expenses',
        null=True,
        blank=True
    )
    value = models.DecimalField('valor', max_digits=7, decimal_places=2)
    paid = models.BooleanField('pago', default=False)

    class Meta:
        ordering = ('-payment_date',)
        verbose_name = 'despesa'
        verbose_name_plural = 'despesas'

    def __str__(self):
        return self.description

    def get_absolute_url(self):
        return reverse_lazy('expense:expense_detail', kwargs={'pk': self.pk})
