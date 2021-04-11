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
