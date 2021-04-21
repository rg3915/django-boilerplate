# Shell script to create a Django project.

# Update USERNAME to your username.

# Usage:
# Type the following command, you can change the project name.

# source boilerplatesimple.sh myproject

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

source /tmp/django-boilerplate/functions.sh

PROJECT=${1-myproject}

echo "Select Django version:"
echo "2 - 2.2.20"
echo "3 - 3.2"
read -p "Choose from 2, 3 [3]: " response
response=${response:-3}

PYTHON_VERSION=3.8.9
DJANGO_VERSION=3.2
USERNAME=${2-rg3915}

if [[ $response == '2' ]]; then
    DJANGO_VERSION=2.2.20
fi

echo "${green}>>> You chose Django $DJANGO_VERSION.${reset}"

echo "${green}>>> The name of the project is '$PROJECT'.${reset}"

echo "${green}>>> Creating .gitignore${reset}"
cp /tmp/django-boilerplate/.gitignore .

create_readme
create_virtualenv
install_django
create_env_gen
create_project

# up one level
cd ..

edit_settings

replace_language_code

edit_urls
edit_accounts_urls
edit_core_urls
edit_core_views
create_management_commands

echo "${green}>>> Editing core/models.py${reset}"
cp /tmp/django-boilerplate/core/models.py $PROJECT/core

# Confirm if create app crm.
create_app_crm

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
