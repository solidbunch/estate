#
# Add new project functions
#

if [ -z "$PROJECT_NAME" ]; then
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} <project_name> is empty ${NOCOLOR}"
  exit 1
fi

# Stop and remove all running containers
source "$INC_DIR"/docker_containers.sh
containers_down


mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"

# Check if folder not empty
if [ -n "$(ls -A "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN")" ]; then
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" is not empty ${NOCOLOR}"
  echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Delete all files inside "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"?"
  read -p "[Estate] Are you sure? y/n - " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then

      # Clear project directory (need sudo for remove www-data and database files)
      read -p "[Estate] For deleting www-data and database files need sudo rights. Are you agree? y/n - " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
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


if [ -f "$INC_DIR"/project_types/"$PROJECT_TYPE".sh ]; then

  source "$INC_DIR"/project_types/"$PROJECT_TYPE".sh

else
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} Unknown <project_type> $PROJECT_TYPE"
  exit 1
fi

echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Type '${YELLOW}cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}'" >&3
echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Go to '${YELLOW}http://"$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}' in your browser " >&3
