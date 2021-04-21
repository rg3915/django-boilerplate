from django.core.management.base import BaseCommand

from {PROJECT}.crm.models import Person
from {PROJECT}.utils import utils as u
from {PROJECT}.utils.progress_bar import progressbar


def get_person():
    first_name = u.gen_first_name()
    last_name = u.gen_last_name()
    d = dict(
        first_name=first_name,
        last_name=last_name,
        email=u.gen_email(first_name, last_name),
    )
    return d


def create_persons():
    aux = []
    for _ in progressbar(range(10), 'Persons'):
        data = get_person()
        obj = Person(**data)
        aux.append(obj)
    Person.objects.bulk_create(aux)


class Command(BaseCommand):
    help = 'Create data.'

    def handle(self, *args, **options):
        self.stdout.write('Create data.')
        create_persons()
