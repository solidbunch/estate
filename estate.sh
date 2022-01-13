#!/bin/bash

#
# Program main file
#

# Stop when error
set -e

# Default values
ESTATE_DIR=/srv/estate
APPS_DIR=/srv/apps
INC_DIR=inc
HOSTS_PATH=/etc/hosts
WSL_HOSTS_PATH=/mnt/c/windows/system32/drivers/etc/hosts
LOCAL_DOMAIN=loc
#QUIET_LOGS=1

# Check $ESTATE_DIR folder exist

# Create $APPS_DIR folder if not exist
#mkdir -p "$APPS_DIR"



# Colors
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# Set log level

if [ -z "${QUIET_LOGS:-}" ]; then
  exec 3>&1
else
  exec 3>/dev/null
fi

# Check system requirements
# System check
#

# Stop all running containers
containers_stop() {
  local CONTAINERS=$(docker ps -a -q)
  if [ -n "$CONTAINERS" ]; then
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Stopping all running containers ..." >&3
    docker stop $(docker ps -a -q)
  else
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} No containers are running" >&3
  fi
}

# Stop and remove all running containers
containers_down() {
  local CONTAINERS=$(docker ps -a -q)
  if [ -n "$CONTAINERS" ]; then
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Stopping all running containers ..." >&3
    docker stop $(docker ps -a -q)
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Removing all stopped containers ..." >&3
    docker rm $(docker ps -a -q)
  else
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} No containers are running" >&3
  fi
}


#
# Parsing arguments
#

# Defaults

parse_arguments() {
  PROJECT_TYPE="foundation"

  while [[ $# -gt 0 ]]; do
    case $1 in
      start)
        PROJECT_NAME="$2"
        if [ -z "$PROJECT_NAME" ]; then
          echo -e "[Estate]${LIGHTRED}[Error]${WHITE} <project_name> is empty ${NOCOLOR}"; exit 1;
        fi
        if [ "$3" ]; then
          PROJECT_TYPE="$3"
          shift # past value PROJECT_TYPE
        fi
        shift # past argument
        shift # past value PROJECT_NAME
        ;;
      hosts)
        # Update hosts file
        hosts_update
        exit
        shift # past argument
        ;;
      stop)
        # Stop all running containers
        containers_stop
        exit
        shift # past argument
        ;;
      down)
        # Stop and remove all running containers
        containers_down
        exit
        shift # past argument
        ;;
      -s|--searchpath)
        SEARCHPATH="$2"
        shift # past argument
        shift # past value
        ;;
      --default)
        DEFAULT=YES
        shift # past argument
        ;;
      -*|--*)
        echo -e "[Estate]${LIGHTRED}[Error]${WHITE} Unknown option $1 ${NOCOLOR}"; exit 1;
        ;;
      *)
        shift # past argument
        ;;
    esac
  done

}

#
# Add new project functions
#

add_project() {
  if [ -z "$PROJECT_NAME" ]; then
    echo -e "[Estate]${LIGHTRED}[Error]${WHITE} <project_name> is empty ${NOCOLOR}"
    exit 1
  fi

  # Stop and remove all running containers

  containers_down

  mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"

  # Check if folder not empty
  if [ -n "$(ls -A "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN")" ]; then
    echo -e "[Estate]${LIGHTRED}[Error]${WHITE} "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" is not empty ${NOCOLOR}"
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Delete all files inside "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"?"
    read -p "[Estate] Are you sure? (y/n) - " -n 10 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then

      # Clear project directory (need sudo for remove www-data and database files)
      read -p "[Estate] For deleting www-data and database files need sudo rights. Type sudo/no - " -n 10 -r
      if [[ $REPLY = sudo ]]; then
        sudo rm -rfv "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"
      else
        rm -rfv "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"
      fi

      mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"
    else
      echo -e "[Estate]${CYAN}[Info]${WHITE} Can't continue with not empty directory ${NOCOLOR}"
      exit
    fi

  fi

  case "$PROJECT_TYPE" in
  foundation)
    #type_foundation
    ;;
  wordpress)
    type_wordpress
    ;;
  php)
    type_php
    ;;
  *)
    echo -e "[Estate]${LIGHTRED}[Error]${WHITE} Unknown <project_type> $PROJECT_TYPE"
    exit 1
    ;;
  esac

  echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Type '${YELLOW}cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}'" >&3
  echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Go to '${YELLOW}http://"$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}' in your browser " >&3

}



# Load project types
#
# Project type Starter Kit Foundation
# Install https://github.com/solidbunch/starter-kit-foundation
#

type_foundation() {
  echo -e "[Estate]${CYAN}[Info]${WHITE} Installing Starter Kit Foundation ... ${NOCOLOR}" >&3

  git clone --depth=1 git@github.com:solidbunch/starter-kit-foundation.git "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"

  cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" || exit

  rm -rf .git

  make secret

  sed -i "s/APP_NAME=your_app_name/APP_NAME=$PROJECT_NAME/" "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN/config/environment/.env.main"

  sed -i "s/APP_DOMAIN=your-app-domain.loc/APP_DOMAIN=$PROJECT_NAME.$LOCAL_DOMAIN/" "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN/config/environment/.env.type.dev"
  sed -i "s/APP_DOMAIN=stage.your-app-domain.com/APP_DOMAIN=stage.$PROJECT_NAME.com/" "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN/config/environment/.env.type.stage"
  sed -i "s/APP_DOMAIN=your-app-domain.com/APP_DOMAIN=$PROJECT_NAME.com/" "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN/config/environment/.env.type.prod"

  make up

  cd "$ESTATE_DIR" || exit

  echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} Project files added to $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3
  echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} Starter Kit Foundation launched in $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3
}



#
# Project type PHP with Database and Nginx
#

type_wordpress() {
  echo -e "[Estate]${CYAN}[Info]${WHITE} Installing WordPress with Database and Apache ... ${NOCOLOR}" >&3

  cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" || exit

  # Add docker-compose.yml file
  cat <<EOT >>docker-compose.yml
version: "3.9"


services:

  database:
    image: mariadb:10.5
    container_name: "${PROJECT_NAME}_database"
    restart: unless-stopped
    env_file: .env
    volumes:
      - ./db-data:/var/lib/mysql

  wordpress:
    image: wordpress:latest
    container_name: "${PROJECT_NAME}_wordpress"
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
  cat <<EOT >>.env

# DataBase options
# Add credentials for database, use a password generator
MYSQL_HOST=database
MYSQL_ROOT_USER=root
MYSQL_ROOT_PASSWORD=Mysql_Root_Password
MYSQL_DATABASE=wordpress_database
MYSQL_USER=wordpress_database_user
MYSQL_PASSWORD=Mysql_Password

WORDPRESS_DB_HOST=database
WORDPRESS_DB_USER=wordpress_database_user
WORDPRESS_DB_PASSWORD=Mysql_Password
WORDPRESS_DB_NAME=wordpress_database


# Environment type
# Use function wp_get_environment_type() to operate with it
#WP_ENVIRONMENT_TYPE=local
WP_ENVIRONMENT_TYPE=development
#WP_ENVIRONMENT_TYPE=staging
#WP_ENVIRONMENT_TYPE=production


# Debug
WP_DEBUG=1
WP_DEBUG_DISPLAY=0
WP_DEBUG_LOG=1



APP_PROTOCOL=http
APP_DOMAIN=${PROJECT_NAME}.${LOCAL_DOMAIN}
APP_PORT=80

EOT

  mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN/public"

  #docker-compose up -d --build

  cd "$ESTATE_DIR" || exit

  echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} Project files added to $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3
  echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} database, php launched in $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3

}


#
# Project type PHP with Database and Nginx
#

type_php() {
  echo -e "[Estate]${CYAN}[Info]${WHITE} Installing PHP with Database and Apache ... ${NOCOLOR}" >&3

  cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" || exit

  # Add docker-compose.yml file
  cat <<EOT >>docker-compose.yml
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
  cat <<EOT >>.env

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

  cat <<EOT >>./public/index.php
<?php
phpinfo();

EOT

  #docker-compose up -d --build

  cd "$ESTATE_DIR" || exit

  echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} Project files added to $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3
  echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} database, php launched in $APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN ${NOCOLOR}" >&3

}


# Operate with hosts file. Need Administrator and root permissions
#
# Edit hosts file records. Add new one and remove unused
# Need Administrator and root permissions.
# Run with Administrator permissions on Windows and with sudo
#

clear_hosts() {

  local LOCAL_HOSTS_PATH=$1

  sed '/^# Start Estate Docker Hosts/,/^# End Estate Docker Hosts/{//!d;};' "$LOCAL_HOSTS_PATH" >hosts.tmp
  sed '/^# Start Estate Docker Hosts/d;/^# End Estate Docker Hosts/d' hosts.tmp >"$LOCAL_HOSTS_PATH"
}

add_hosts() {

  local LOCAL_HOSTS_PATH=$1

  echo '# Start Estate Docker Hosts' >estate_hosts.tmp

  for dir in $(find "$APPS_DIR" -maxdepth 1 -type d -follow -print | sort -V); do

    if [ "$dir" != "$APPS_DIR" ]; then
      echo "127.0.0.1	"$(basename "$dir") >>estate_hosts.tmp
    fi

  done

  echo '# End Estate Docker Hosts' >>estate_hosts.tmp

  cat estate_hosts.tmp "$LOCAL_HOSTS_PATH" >hosts.tmp

  rm estate_hosts.tmp

  mv hosts.tmp "$LOCAL_HOSTS_PATH"

}

hosts_update() {

  if [ -w "$HOSTS_PATH" ]; then

    clear_hosts "$HOSTS_PATH"
    add_hosts "$HOSTS_PATH"

    echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} $HOSTS_PATH file updated ${NOCOLOR}" >&3
  else

    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} $HOSTS_PATH is Not Writable. Run Estate with sudo${NOCOLOR}" >&3

    # If WSL running - not necessary update linux hosts wright now
    if [ -f "$WSL_HOSTS_PATH" ]; then
      echo -e "[Estate]${CYAN}[Info]${NOCOLOR} On WSL not necessary update linux hosts wright now, by default it will update automatically when WSL restart (see /etc/wsl.conf) ${NOCOLOR}" >&3
    fi

  fi

  # If WSL running - need to update windows hosts too
  if [ -f "$WSL_HOSTS_PATH" ]; then

    if [ -w "$WSL_HOSTS_PATH" ]; then

      clear_hosts "$WSL_HOSTS_PATH"
      add_hosts "$WSL_HOSTS_PATH"

      echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} $WSL_HOSTS_PATH file updated ${NOCOLOR}" >&3

    else

      echo -e "[Estate]${CYAN}[Info]${NOCOLOR} $WSL_HOSTS_PATH is Not Writable. Run Terminal as Administrator${NOCOLOR}" >&3

    fi

  fi

}





# Run program

# Parse arguments
parse_arguments "$@"

# Add new project
add_project

# Update hosts file
hosts_update


echo -e "[Estate]${LIGHTGREEN}[Success]${WHITE} New project $PROJECT_NAME ready! ${NOCOLOR}" >&3
