# django-boilerplate-simple

#### Simple Boilerplate to create Django project.

This boilerplate creates a simple Django project with a core app and some pre-defined settings.

The project contains:

* Settings config
* App accounts
* App core
* App crm

## Packages

Packages used in conjunction with Django.

* [Python 3.8.7](https://www.python.org/downloads/)
* [Django 3.1.8](https://www.djangoproject.com/)
* [dj-database-url](https://pypi.org/project/dj-database-url/)
* [django-extensions](https://django-extensions.readthedocs.io/en/latest/installation_instructions.html)
* [isort](https://pypi.org/project/isort/)
* [python-decouple](https://pypi.org/project/python-decouple/)


## Usage

This script run in Unix.

```
git clone https://github.com/rg3915/django-boilerplate-simple.git /tmp/django-boilerplate-simple
# Copy this file to your actual folder.
cp /tmp/django-boilerplate-simple/boilerplatesimple.sh .
```

Type the following command. You can change the project name.

```
source boilerplatesimple.sh myproject
```


### Alias

If yout want to use a alias.

```
alias bsimple='git clone https://github.com/rg3915/django-boilerplate-simple.git /tmp/django-boilerplate-simple;
cp /tmp/django-boilerplate-simple/boilerplatesimple.sh .
printf "Type:\n`tput setaf 2`source boilerplatesimple.sh myproject\n"'
```

