# Shell script to create a very simple Django project.

# Usage:
# Type the following command, you can change the project name.

# source boilerplatesimple.sh myproject

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

PROJECT=${1-myproject}

echo "Select Django version:"
echo "2 - 2.2.20"
echo "3 - 3.1.8"
read -p "Choose from 2, 3 [3]: " response
response=${response:-3}

PYTHON_VERSION=3.8.7
DJANGO_VERSION=3.1.8

if [[ $response == '2' ]]; then
    DJANGO_VERSION=2.2.20
fi

echo "${green}>>> You chose Django $DJANGO_VERSION.${reset}"

echo "${green}>>> The name of the project is '$PROJECT'.${reset}"

echo "${green}>>> Creating .gitignore${reset}"
cp /tmp/django-boilerplate-simple/.gitignore .

echo "${green}>>> Creating README.md${reset}"
cat << EOF > README.md
## This project was done with:

* Python $PYTHON_VERSION
* Django $DJANGO_VERSION

## How to run project?

* Clone this repository.
* Create virtualenv with Python 3.
* Active the virtualenv.
* Install dependences.
* Run the migrations.

\`\`\`
git clone https://github.com/rg3915/$PROJECT.git
cd $PROJECT
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python contrib/env_gen.py
python manage.py migrate
\`\`\`
EOF

echo "${green}>>> Creating virtualenv${reset}"
python -m venv .venv
echo "${green}>>> .venv is created${reset}"

# active
sleep 2
echo "${green}>>> activate the .venv${reset}"
source .venv/bin/activate
PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
sleep 2

# Install Django
echo "${green}>>> Installing the Django${reset}"
pip install -U pip
pip install django==$DJANGO_VERSION dj-database-url django-extensions django-localflavor isort python-decouple
echo Django==$DJANGO_VERSION > requirements.txt
pip freeze | grep dj-database-url >> requirements.txt
pip freeze | grep django-extensions >> requirements.txt
pip freeze | grep django-localflavor >> requirements.txt
pip freeze | grep isort >> requirements.txt
pip freeze | grep python-decouple >> requirements.txt

echo "${green}>>> Creating contrib/env_gen.py${reset}"
cp -r /tmp/django-boilerplate-simple/contrib/ .

echo "${green}>>> Running contrib/env_gen.py${reset}"
python contrib/env_gen.py

# Create project
echo "${green}>>> Creating the project '$PROJECT' ...${reset}"
django-admin.py startproject $PROJECT .
cd $PROJECT
echo "${green}>>> Creating the app 'core' ...${reset}"
python ../manage.py startapp core

echo "${green}>>> Creating the app 'accounts' ...${reset}"
python ../manage.py startapp accounts

echo "${green}>>> Creating the app 'crm' ...${reset}"
python ../manage.py startapp crm

# up one level
cd ..

# ********** EDITING FILES **********
echo "${green}>>> Editing settings.py${reset}"
cp /tmp/django-boilerplate-simple/settings.py $PROJECT/

# Substitui o nome do projeto.
sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/settings.py
sed -i "s/{DJANGO_VERSION}/$DJANGO_VERSION/g" $PROJECT/settings.py

# Troca import, BASE_DIR
if [[ $response == '2' ]]; then
    sed -i "s/{LINK_VERSION}/2.2/g" $PROJECT/settings.py
    sed -i "s/# SETTINGS_IMPORT/import os/g" $PROJECT/settings.py
    sed -i "s/# SETTINGS_BASE_DIR/BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))/g" $PROJECT/settings.py
    sed -i "s/# DEFAULT_DBURL/default_dburl = 'sqlite:\/\/\/' + os.path.join(BASE_DIR, 'db.sqlite3')/g" $PROJECT/settings.py
    sed -i "s/# STATIC_ROOT/STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')/g" $PROJECT/settings.py
else
    sed -i "s/{LINK_VERSION}/3.1/g" $PROJECT/settings.py
    sed -i "s/# SETTINGS_IMPORT/from pathlib import Path/g" $PROJECT/settings.py
    sed -i "s/# SETTINGS_BASE_DIR/BASE_DIR = Path(__file__).resolve().parent.parent/g" $PROJECT/settings.py
    sed -i "s/# DEFAULT_DBURL/default_dburl = 'sqlite:\/\/\/' + str(BASE_DIR \/ 'db.sqlite3')/g" $PROJECT/settings.py
    sed -i "s/# STATIC_ROOT/STATIC_ROOT = BASE_DIR.joinpath('staticfiles')/g" $PROJECT/settings.py
fi

read -p "Replace LANGUAGE_CODE to pt-br? [Y/n] " response
response=${response:-Y}
if [[ $response == 'Y' || $response == 'y' ]]; then
    # replace LANGUAGE_CODE to pt-br
    sed -i "s/en-us/pt-br/g" $PROJECT/settings.py
    # replace TIME_ZONE to America/Sao_Paulo
    sed -i "s/UTC/America\/Sao_Paulo/g" $PROJECT/settings.py
fi

echo "${green}>>> Editing urls.py${reset}"
cat << EOF > $PROJECT/urls.py
from django.urls import include, path
from django.contrib import admin


urlpatterns = [
    path('', include('$PROJECT.core.urls', namespace='core')),
    path('accounts/', include('$PROJECT.accounts.urls')),  # without namespace
    path('crm/', include('$PROJECT.crm.urls', namespace='crm')),
    path('admin/', admin.site.urls),
]
EOF

# ********** EDITING accounts **********
echo "${green}>>> Editing accounts/urls.py${reset}"
cat << EOF > $PROJECT/accounts/urls.py
from django.contrib.auth.views import LoginView, LogoutView
from django.urls import path

urlpatterns = [
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
]

EOF


# ********** EDITING core **********
echo "${green}>>> Editing core/models.py${reset}"
cp /tmp/django-boilerplate-simple/models.py $PROJECT/core/models.py

echo "${green}>>> Editing core/urls.py${reset}"
cat << EOF > $PROJECT/core/urls.py
from django.urls import path

from $PROJECT.core import views as v

app_name = 'core'


urlpatterns = [
    path('', v.index, name='index'),
]

EOF

echo "${green}>>> Editing core/views.py${reset}"
cat << EOF > $PROJECT/core/views.py
from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from django.shortcuts import render


# @login_required
def index(request):
    return HttpResponse('<h1>Django</h1><p>Página simples.</p>')


# @login_required
# def index(request):
#     template_name = 'index.html'
#     return render(request, template_name)

EOF

# Create management commands.
echo "${green}>>> Editing management/commands.${reset}"
mkdir -p $PROJECT/core/management/commands
touch $PROJECT/core/management/commands/__init__.py

cat << EOF > $PROJECT/core/management/commands/hello.py
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = 'Print hello world.'

    def add_arguments(self, parser):
        # Argumento nomeado
        parser.add_argument(
            '--awards', '-a',
            action='store_true',
            help='Ajuda da opção awards.'
        )

    def handle(self, *args, **options):
        self.stdout.write('Hello world.')
        if options['awards']:
            self.stdout.write('Awards')

EOF



# ********** EDITING crm **********
echo "${green}>>> Editing crm/admin.py${reset}"
cat << EOF > $PROJECT/crm/admin.py
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

EOF

echo "${green}>>> Editing crm/forms.py${reset}"
cat << EOF > $PROJECT/crm/forms.py
from django import forms

from .models import Person


class PersonForm(forms.ModelForm):

    class Meta:
        model = Person
        fields = '__all__'

EOF

echo "${green}>>> Editing crm/models.py${reset}"
cat << EOF > $PROJECT/crm/models.py
from django.db import models
from django.urls import reverse_lazy

from $PROJECT.core.models import (
    Active,
    Address,
    Document,
    TimeStampedModel,
    UuidModel
)


class Person(UuidModel, TimeStampedModel, Address, Document, Active):
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

    # def get_absolute_url(self):
    #     return reverse_lazy('crm:person_detail', kwargs={'pk': self.pk})

EOF

echo "${green}>>> Editing crm/urls.py${reset}"
cat << EOF > $PROJECT/crm/urls.py
from django.urls import path

from $PROJECT.crm import views as v

app_name = 'crm'


urlpatterns = [
    # path(),
]

EOF


# migrate
python manage.py makemigrations
python manage.py migrate

read -p "Create superuser? [Y/n] " answer
answer=${answer:-Y}
if [[ $answer == 'Y' || $answer == 'y' ]]; then
    echo "${green}>>> Creating a 'admin' user ...${reset}"
    echo "${green}>>> The password must contain at least 8 characters.${reset}"
    echo "${green}>>> Password suggestions: demodemo${reset}"
    python manage.py createsuperuser --username='admin' --email=''
fi

echo "${red}>>> Important: Dont add .env in your public repository.${reset}"
echo "${red}>>> KEEP YOUR SECRET_KEY AND PASSWORDS IN SECRET!!!\n${reset}"
echo "${green}>>> Done${reset}"
# https://www.gnu.org/software/sed/manual/sed.html

# Move this file to /tmp folder.
mv boilerplatesimple.sh /tmp
