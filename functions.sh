create_readme() {
    echo "${green}>>> Creating README.md${reset}"
    cp /tmp/django-boilerplate/_README.md README.md

    sed -i "s/{PYTHON_VERSION}/$PYTHON_VERSION/g" README.md
    sed -i "s/{DJANGO_VERSION}/$DJANGO_VERSION/g" README.md
    sed -i "s/{USERNAME}/$USERNAME/g" README.md
    sed -i "s/{PROJECT}/$PROJECT/g" README.md
}

create_virtualenv() {
    echo "${green}>>> Creating virtualenv${reset}"
    python -m venv .venv
    echo "${green}>>> .venv is created${reset}"

    # active
    sleep 2
    echo "${green}>>> activate the .venv${reset}"
    source .venv/bin/activate
    PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
    sleep 2
}

install_django() {
    # Install Django
    echo "${green}>>> Installing the Django${reset}"
    pip install -U pip
    pip install django==$DJANGO_VERSION dj-database-url django-extensions django-localflavor django-widget-tweaks django-seed isort python-decouple faker ipdb
    echo Django==$DJANGO_VERSION > requirements.txt
    pip freeze | grep dj-database-url >> requirements.txt
    pip freeze | grep django-extensions >> requirements.txt
    pip freeze | grep django-seed >> requirements.txt
    pip freeze | grep django-widget-tweaks >> requirements.txt
    pip freeze | grep Faker >> requirements.txt
    pip freeze | grep isort >> requirements.txt
    pip freeze | grep python-decouple >> requirements.txt
    pip install ipython[notebook]
}

create_env_gen() {
    echo "${green}>>> Creating contrib/env_gen.py${reset}"
    cp -r /tmp/django-boilerplate/contrib/ .

    echo "${green}>>> Running contrib/env_gen.py${reset}"
    python contrib/env_gen.py
}

create_project() {
    # Create project
    echo "${green}>>> Creating the project '$PROJECT' ...${reset}"
    django-admin startproject $PROJECT .
    cd $PROJECT
    echo "${green}>>> Creating the app 'core' ...${reset}"
    python ../manage.py startapp core

    echo "${green}>>> Creating the app 'accounts' ...${reset}"
    python ../manage.py startapp accounts
    # up one level
    cd ..
}

edit_settings() {
    echo "${green}>>> Editing settings.py${reset}"
    cp /tmp/django-boilerplate/settings.py $PROJECT/

    # Substitui o nome do projeto.
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/settings.py
    sed -i "s/{DJANGO_VERSION}/$DJANGO_VERSION/g" $PROJECT/settings.py

    # Troca import, BASE_DIR
    if [[ $DJANGO == '2' ]]; then
        sed -i "s/{LINK_VERSION}/2.2/g" $PROJECT/settings.py
        sed -i "s/# SETTINGS_IMPORT/import os/g" $PROJECT/settings.py
        sed -i "s/{SETTINGS_BASE_DIR}/BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))/g" $PROJECT/settings.py
        sed -i "s/{DEFAULT_DBURL}/default_dburl = 'sqlite:\/\/\/' + os.path.join(BASE_DIR, 'db.sqlite3')/g" $PROJECT/settings.py
        sed -i "s/{STATIC_ROOT}/STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')/g" $PROJECT/settings.py
        sed -i "s/DEFAULT_AUTO_FIELD/# DEFAULT_AUTO_FIELD/g" $PROJECT/settings.py
    else
        sed -i "s/{LINK_VERSION}/3.2/g" $PROJECT/settings.py
        sed -i "s/# SETTINGS_IMPORT/from pathlib import Path/g" $PROJECT/settings.py
        sed -i "s/{SETTINGS_BASE_DIR}/BASE_DIR = Path(__file__).resolve().parent.parent/g" $PROJECT/settings.py
        sed -i "s/{DEFAULT_DBURL}/default_dburl = 'sqlite:\/\/\/' + str(BASE_DIR \/ 'db.sqlite3')/g" $PROJECT/settings.py
        sed -i "s/{STATIC_ROOT}/STATIC_ROOT = BASE_DIR.joinpath('staticfiles')/g" $PROJECT/settings.py
    fi
}

edit_app_accounts() {
    if [[ $DJANGO == '3' ]]; then
        sed -i "s/accounts/$PROJECT.accounts/g" $PROJECT/accounts/apps.py
    fi
}

edit_app_core() {
    if [[ $DJANGO == '3' ]]; then
        sed -i "s/core/$PROJECT.core/g" $PROJECT/core/apps.py
    fi
}

edit_app_crm() {
    if [[ $DJANGO == '3' ]]; then
        sed -i "s/crm/$PROJECT.crm/g" $PROJECT/crm/apps.py
    fi
}

edit_app_expense() {
    if [[ $DJANGO == '3' ]]; then
        sed -i "s/expense/$PROJECT.expense/g" $PROJECT/expense/apps.py
    fi
}

edit_urls() {
    echo "${green}>>> Editing urls.py${reset}"
    cp /tmp/django-boilerplate/urls.py $PROJECT/
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/urls.py
}

edit_accounts_forms() {
    echo "${green}>>> Editing accounts/forms.py${reset}"
    cp /tmp/django-boilerplate/accounts/forms.py $PROJECT/accounts
}

edit_accounts_views() {
    echo "${green}>>> Editing accounts/views.py${reset}"
    cp /tmp/django-boilerplate/accounts/views.py $PROJECT/accounts
}

edit_accounts_urls() {
    echo "${green}>>> Editing accounts/urls.py${reset}"
    cp /tmp/django-boilerplate/accounts/urls.py $PROJECT/accounts
}

edit_core_urls() {
    echo "${green}>>> Editing core/urls.py${reset}"
    cp /tmp/django-boilerplate/core/urls.py $PROJECT/core
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/core/urls.py
}

edit_core_views() {
    echo "${green}>>> Editing core/views.py${reset}"
    cp /tmp/django-boilerplate/core/views.py $PROJECT/core
}

create_utils() {
    echo "${green}>>> Editing utils.${reset}"
    mkdir -p $PROJECT/utils
    cp /tmp/django-boilerplate/utils/* $PROJECT/utils
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/core/management/commands/create_data.py
}

create_accounts_templates() {
    echo "${green}>>> Coping accounts templates.${reset}"
    mkdir -p $PROJECT/accounts/templates/accounts
    cp -R /tmp/django-boilerplate/accounts/templates/* $PROJECT/accounts/templates
}

create_core_templates() {
    echo "${green}>>> Coping core templates.${reset}"
    mkdir -p $PROJECT/core/templates/includes
    cp -R /tmp/django-boilerplate/core/templates/* $PROJECT/core/templates
}

create_static() {
    echo "${green}>>> Coping static.${reset}"
    mkdir -p $PROJECT/core/static/css/icons
    mkdir $PROJECT/core/static/{img,fonts}
    cp -R /tmp/django-boilerplate/core/static/* $PROJECT/core/static
}

create_crm_templates() {
    echo "${green}>>> Coping crm templates.${reset}"
    mkdir -p $PROJECT/crm/templates/crm
    cp /tmp/django-boilerplate/crm/templates/crm/* $PROJECT/crm/templates/crm
}

create_management_commands() {
    echo "${green}>>> Editing management/commands.${reset}"
    mkdir -p $PROJECT/core/management/commands
    cp /tmp/django-boilerplate/core/management/commands/* $PROJECT/core/management/commands
}

edit_crm_mixins() {
    echo "${green}>>> Editing crm/mixins.py${reset}"
    cp /tmp/django-boilerplate/crm/mixins.py $PROJECT/crm
}

edit_crm_admin() {
    echo "${green}>>> Editing crm/admin.py${reset}"
    cp /tmp/django-boilerplate/crm/admin.py $PROJECT/crm
}

edit_crm_forms() {
    echo "${green}>>> Editing crm/forms.py${reset}"
    cp /tmp/django-boilerplate/crm/forms.py $PROJECT/crm
}

edit_crm_models() {
    echo "${green}>>> Editing crm/models.py${reset}"
    cp /tmp/django-boilerplate/crm/models.py $PROJECT/crm
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/crm/models.py
}

edit_crm_urls() {
    echo "${green}>>> Editing crm/urls.py${reset}"
    cp /tmp/django-boilerplate/crm/urls.py $PROJECT/crm
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/crm/urls.py
}

edit_crm_views() {
    echo "${green}>>> Editing crm/views.py${reset}"
    cp /tmp/django-boilerplate/crm/views.py $PROJECT/crm
}

edit_expense_admin() {
    echo "${green}>>> Editing expense/admin.py${reset}"
    cp /tmp/django-boilerplate/expense/admin.py $PROJECT/expense
}

edit_expense_forms() {
    echo "${green}>>> Editing expense/forms.py${reset}"
    cp /tmp/django-boilerplate/expense/forms.py $PROJECT/expense
}

edit_expense_mixins() {
    echo "${green}>>> Editing expense/mixins.py${reset}"
    cp /tmp/django-boilerplate/expense/mixins.py $PROJECT/expense
}

edit_expense_models() {
    echo "${green}>>> Editing expense/models.py${reset}"
    cp /tmp/django-boilerplate/expense/models.py $PROJECT/expense
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/expense/models.py
}

edit_expense_urls() {
    echo "${green}>>> Editing expense/urls.py${reset}"
    cp /tmp/django-boilerplate/expense/urls.py $PROJECT/expense
    sed -i "s/{PROJECT}/$PROJECT/g" $PROJECT/expense/urls.py
}

edit_expense_views() {
    echo "${green}>>> Editing expense/views.py${reset}"
    cp /tmp/django-boilerplate/expense/views.py $PROJECT/expense
}

create_expense_templates() {
    echo "${green}>>> Coping expense templates.${reset}"
    mkdir -p $PROJECT/expense/templates/expense/includes
    cp /tmp/django-boilerplate/expense/templates/expense/* $PROJECT/expense/templates/expense
}

create_app_crm() {
    echo "${green}>>> Creating the app 'crm' ...${reset}"
    cd $PROJECT
    python ../manage.py startapp crm
    cd ..

    edit_crm_admin
    edit_crm_forms
    edit_crm_models
    edit_crm_urls
    edit_crm_views
}

create_app_expense() {
    echo "${green}>>> Creating the app 'expense' ...${reset}"
    cd $PROJECT
    python ../manage.py startapp expense
    cd ..

    edit_app_expense
    edit_expense_admin
    edit_expense_forms
    edit_expense_mixins
    edit_expense_models
    edit_expense_urls
    edit_expense_views
    create_expense_templates
}

create_superuser() {
    read -p "Create superuser? [Y/n] " answer
    answer=${answer:-Y}
    if [[ $answer == 'Y' || $answer == 'y' ]]; then
        echo "${green}>>> Creating a 'admin' user ...${reset}"
        echo "${green}>>> The password must contain at least 8 characters.${reset}"
        echo "${green}>>> Password suggestions: demodemo${reset}"
        python manage.py createsuperuser --username='admin' --email=''
    fi
}
