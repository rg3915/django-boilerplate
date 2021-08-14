from django.urls import reverse_lazy
from django.views.generic import CreateView
from {PROJECT}.accounts.forms import SignupForm


class SignUpView(CreateView):
    form_class = SignupForm
    success_url = reverse_lazy('login')
    template_name = 'accounts/signup.html'
