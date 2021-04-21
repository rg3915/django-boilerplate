import string
from datetime import date, datetime, timedelta
from random import choice, random, randrange

from django.utils.text import slugify
from faker import Faker

fake = Faker()


def gen_string(max_length):
    return str(''.join(choice(string.ascii_letters) for i in range(max_length)))


gen_string.required = ['max_length']


def gen_digits(max_length: int):
    '''Gera dígitos numéricos.'''
    return str(''.join(choice(string.digits) for i in range(max_length)))


def gen_first_name():
    return fake.first_name()


def gen_last_name():
    return fake.last_name()


def gen_email(first_name: str, last_name: str, company: str = None):
    first_name = slugify(first_name)
    last_name = slugify(last_name)
    email = f'{first_name}.{last_name}@email.com'
    return email


def gen_date(min_year=2019, max_year=datetime.now().year):
    # gera um date no formato yyyy-mm-dd
    start = date(min_year, 1, 1)
    years = max_year - min_year + 1
    end = start + timedelta(days=365 * years)
    return start + (end - start) * random()


def gen_rg():
    return gen_digits(10)


def gen_cpf():
    def calcula_digito(digs):
        s = 0
        qtd = len(digs)
        for i in range(qtd):
            s += n[i] * (1 + qtd - i)
        res = 11 - s % 11
        if res >= 10:
            return 0
        return res
    n = [randrange(10) for i in range(9)]
    n.append(calcula_digito(n))
    n.append(calcula_digito(n))
    return "%d%d%d%d%d%d%d%d%d%d%d" % tuple(n)


def gen_phone():
    return f'{gen_digits(2)} {gen_digits(4)}-{gen_digits(4)}'


def gen_text():
    return fake.paragraph(nb_sentences=5)
