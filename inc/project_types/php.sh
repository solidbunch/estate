#
# Project type PHP with Database and Nginx
#

echo -e "[Estate]${CYAN}[Info]${WHITE} Installing PHP with Database and Apache ... ${NOCOLOR}" >&3


cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" || exit

# Add docker-compose.yml file
cat <<EOT >> docker-compose.yml
version: "3.9"


services:

  database:
    image: mariadb:10.5
    container_name: "${PROJECT_NAME}_database"
    restart: unless-stopped
    env_file: .env
    volumes:
      - ./db-data:/var/lib/mysql

  php:
    image: php:7.4-apache
    container_name: "${PROJECT_NAME}_php"
    restart: unless-stopped
    depends_on:
      - database
    env_file: .env
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./public:/var/www/html

EOT

# Add .env file
cat <<EOT >> .env

# DataBase options
# Add credentials for database, use a password generator
MYSQL_HOST=database
MYSQL_ROOT_USER=root
MYSQL_ROOT_PASSWORD=Mysql_Root_Password
MYSQL_DATABASE=database_name
MYSQL_USER=database_user
MYSQL_PASSWORD=Mysql_Password


APP_PROTOCOL=http
APP_DOMAIN=${PROJECT_NAME}.${LOCAL_DOMAIN}
APP_PORT=80

EOT

mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN/public"

cat <<EOT >> ./public/index.php
<?php
phpinfo();

EOT

docker-compose up -d --build



cd "$ESTATE_DIR" || exit

echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} Project files added to $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3
echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} database, php launched in $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3