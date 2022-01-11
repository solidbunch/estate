#
# Add new project functions
#

if [ -z "$PROJECT_NAME" ]; then
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} <project_name> is empty ${NOCOLOR}"
  exit 1
fi

mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"

# Check if folder not empty
if [ -n "$(ls -A "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN")" ]; then
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" is not empty ${NOCOLOR}"
  exit 1
fi

# Stop and remove all running containers
CONTAINERS=$(docker ps -a -q)
if [ -n "$CONTAINERS" ]; then
  echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Stopping and removing all running containers ..." >&3
  docker stop $CONTAINERS
  docker rm $CONTAINERS
fi

if [ -f "$INC_DIR"/project_types/"$PROJECT_TYPE".sh ]; then

  source "$INC_DIR"/project_types/"$PROJECT_TYPE".sh
else
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} Unknown <project_type> $PROJECT_TYPE"
  exit 1
fi

echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Type '${YELLOW}cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}'" >&3
echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Go to '${YELLOW}http://"$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}' in your browser " >&3
