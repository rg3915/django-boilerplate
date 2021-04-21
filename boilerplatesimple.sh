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
echo "3 - 3.1.8"
read -p "Choose from 2, 3 [3]: " response
response=${response:-3}

PYTHON_VERSION=3.8.9
DJANGO_VERSION=3.1.8
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

read -p "Replace LANGUAGE_CODE to pt-br? [Y/n] " response_language_code
response_language_code=${response_language_code:-Y}
if [[ $response_language_code == 'Y' || $response_language_code == 'y' ]]; then
    # replace LANGUAGE_CODE to pt-br
    sed -i "s/en-us/pt-br/g" $PROJECT/settings.py
    # replace TIME_ZONE to America/Sao_Paulo
    sed -i "s/UTC/America\/Sao_Paulo/g" $PROJECT/settings.py
fi

edit_urls
edit_accounts_urls
edit_core_urls
edit_core_views
create_management_commands

# ********** EDITING core models.py **********
echo "${green}>>> Editing core/models.py${reset}"
cp /tmp/django-boilerplate/core/models.py $PROJECT/core


read -p "Create the app 'crm'? [y/N] " response_crm
response_crm=${response_crm:-N}
if [[ $response_crm == 'Y' || $response_crm == 'y' ]]; then
    echo "${green}>>> Creating the app 'crm' ...${reset}"
    cd $PROJECT
    python ../manage.py startapp crm
    cd ..

    edit_crm_admin
    edit_crm_forms
    edit_crm_models
    edit_crm_urls
    edit_crm_views
fi


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
