from django import forms

from .models import Person


class PersonForm(forms.ModelForm):
    required_css_class = 'required'

    class Meta:
        model = Person
        # fields = '__all__'
        fields = (
            'first_name',
            'last_name',
            'email',
            'address',
            'address_number',
            'complement',
            'district',
            'city',
            'uf',
            'cep',
            'country',
            'cpf',
            'rg',
            'cnh',
            'active',
        )

    def __init__(self, *args, **kwargs):
        super(PersonForm, self).__init__(*args, **kwargs)
        for field_name, field in self.fields.items():
            field.widget.attrs['class'] = 'form-control'
        self.fields['active'].widget.attrs['class'] = None
