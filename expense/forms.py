from django import forms

from .models import Expense


class ExpenseForm(forms.ModelForm):
    required_css_class = 'required'

    payment_date = forms.DateField(
        label='Data de pagamento',
        widget=forms.DateInput(
            format='%Y-%m-%d',
            attrs={
                'type': 'date',
            }),
        input_formats=('%Y-%m-%d',),
        required=False,
    )

    class Meta:
        model = Expense
        fields = ('description', 'payment_date', 'person', 'value', 'paid')

    def __init__(self, *args, **kwargs):
        super(ExpenseForm, self).__init__(*args, **kwargs)
        for field_name, field in self.fields.items():
            field.widget.attrs['class'] = 'form-control'
        self.fields['paid'].widget.attrs['class'] = None
