## This project was done with:

* [Python {PYTHON_VERSION}](https://www.python.org/)
* [Django {DJANGO_VERSION}](https://www.djangoproject.com/)

## How to run project?

* Clone this repository.
* Create virtualenv with Python 3.
* Active the virtualenv.
* Install dependences.
* Run the migrations.

```
git clone https://github.com/{USERNAME}/{PROJECT}.git
cd {PROJECT}
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python contrib/env_gen.py
python manage.py migrate
```

## Django Seed

if running [django-seed](https://github.com/Brobin/django-seed) type:

```
python manage.py seed crm expense --number=15
```


## Este projeto foi feito com:

* [Python {PYTHON_VERSION}](https://www.python.org/)
* [Django {DJANGO_VERSION}](https://www.djangoproject.com/)

## Como rodar o projeto?

* Clone esse repositório.
* Crie um virtualenv com Python 3.
* Ative o virtualenv.
* Instale as dependências.
* Rode as migrações.

```
git clone https://github.com/{USERNAME}/{PROJECT}.git
cd {PROJECT}
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python contrib/env_gen.py
python manage.py migrate
```


## Django Seed

Se quiser rodar o [django-seed](https://github.com/Brobin/django-seed) digite:

```
python manage.py seed crm expense --number=15
```
