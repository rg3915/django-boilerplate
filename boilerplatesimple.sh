# Shell script to create a Django project.

# Update USERNAME to your username.

# Usage:
# Type the following command, you can change the project name.

# source boilerplatesimple.sh
# source boilerplatesimple.sh myproject
# source boilerplatesimple.sh myproject crm

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

source /tmp/django-boilerplate/functions.sh

PROJECT=${1:-myproject}

APP_CRM=${2}

echo "Select Django version:"
echo "2 - 2.2.20"
echo "3 - 3.2"
read -p "Choose from 2, 3 [3]: " DJANGO
DJANGO=${DJANGO:-3}

# read -p "Create the app 'crm'? [y/N] " APP_CRM
# APP_CRM=${APP_CRM:-N}

PYTHON_VERSION=3.8.9
DJANGO_VERSION=3.2
USERNAME="rg3915"

if [[ $DJANGO == '2' ]]; then
    DJANGO_VERSION=2.2.20
fi

echo "${green}>>> You chose Django $DJANGO_VERSION.${reset}"

echo "${green}>>> The name of the project is '$PROJECT'.${reset}"

echo "${green}>>> LANGUAGE_CODE is pt-br.${reset}"

if [ ! -z "$APP_CRM" ]; then
    if [ $APP_CRM == 'crm' ]; then
        echo "${green}>>> Create the app 'crm'.${reset}"
    fi
fi

sleep 1

echo "${green}>>> Creating .gitignore${reset}"
cp /tmp/django-boilerplate/.gitignore .

create_readme
create_virtualenv
install_django
create_env_gen
create_project

edit_settings
edit_urls
edit_accounts_urls
edit_core_urls
edit_core_views
create_management_commands
create_utils

echo "${green}>>> Editing core/models.py${reset}"
cp /tmp/django-boilerplate/core/models.py $PROJECT/core

edit_app_accounts
edit_app_core


if [ ! -z "$APP_CRM" ]; then
    # Confirm if create app crm.
    create_app_crm
    if [ $APP_CRM == 'crm' ]; then
        edit_app_crm
    fi
fi

# migrate
python manage.py makemigrations
python manage.py migrate

# Confirm if create superuser.
create_superuser

echo "${red}>>> Important: Dont add .env in your public repository.${reset}"
echo "${red}>>> KEEP YOUR SECRET_KEY AND PASSWORDS IN SECRET!!!\n${reset}"
echo "${green}>>> Done${reset}"
# https://www.gnu.org/software/sed/manual/sed.html

# Move this file to /tmp folder.
mv boilerplatesimple.sh /tmp
