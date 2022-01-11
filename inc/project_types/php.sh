#
# Project type PHP with Database and Nginx
#

echo -e "[Estate]${CYAN}[Info]${WHITE} Installing PHP with Database and Nginx ... ${NOCOLOR}" >&3


cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" || exit

echo 'version: "3.9"' >>docker-compose.yml
echo 'services:' >>docker-compose.yml
echo '  database:' >>docker-compose.yml
echo '    image: mariadb:10.5' >>docker-compose.yml
echo '    restart: unless-stopped' >>docker-compose.yml
echo '    volumes:' >>docker-compose.yml
echo '      - ./db-data:/var/lib/mysql' >>docker-compose.yml
echo '  php:' >>docker-compose.yml
echo '    image: php:7.4' >>docker-compose.yml
echo '    restart: unless-stopped' >>docker-compose.yml
echo '    volumes:' >>docker-compose.yml
echo '      - ./public:/var/www/html' >>docker-compose.yml

docker-compose up -d --build


cd "$ESTATE_DIR" || exit

echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} Project files added to $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3
echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} database, php launched in $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3