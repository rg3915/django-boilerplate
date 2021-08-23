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

PROJECT=${1:-myproject}

echo "Select Django version:"
echo "2 - 2.2.*"
echo "3 - 3.2.*"
read -p "Choose from 2, 3 [3]: " DJANGO
DJANGO=${DJANGO:-3}

PYTHON_VERSION=3.9.6
DJANGO_VERSION=3.2.*
USERNAME="rg3915"

if [[ $DJANGO == '2' ]]; then
    DJANGO_VERSION=2.2.*
fi

echo "${green}>>> You chose Django $DJANGO_VERSION.${reset}"

echo "${green}>>> The name of the project is '$PROJECT'.${reset}"

echo "${green}>>> LANGUAGE_CODE is pt-br.${reset}"

echo "${green}>>> Create the app 'crm'.${reset}"

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
edit_accounts_forms
edit_accounts_views
edit_core_urls
edit_core_views
create_management_commands
create_utils
create_accounts_templates
create_core_templates
create_static

echo "${green}>>> Editing core/models.py${reset}"
cp /tmp/django-boilerplate/core/models.py $PROJECT/core

edit_app_accounts
edit_app_core

create_app_crm
edit_app_crm
edit_crm_mixins
create_crm_templates

create_app_expense

# Remove comments of settings.py
sed -i "s/# '$PROJECT.crm.apps.CrmConfig'/'$PROJECT.crm.apps.CrmConfig'/g" $PROJECT/settings.py
sed -i "s/# '$PROJECT.expense.apps.ExpenseConfig'/'$PROJECT.expense.apps.ExpenseConfig'/g" $PROJECT/settings.py

# migrate
python manage.py makemigrations
python manage.py migrate

# Confirm if create superuser.
create_superuser

echo "${red}>>> Important: Dont add .env in your public repository.${reset}"
echo "${red}>>> KEEP YOUR SECRET_KEY AND PASSWORDS IN SECRET!!!\n${reset}"
echo "${green}>>> [Optional] run python manage.py seed crm expense --number=15${reset}"
echo "${green}>>> Done${reset}"
# https://www.gnu.org/software/sed/manual/sed.html

# Move this file to /tmp folder.
mv boilerplatesimple.sh /tmp
