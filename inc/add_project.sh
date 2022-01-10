#
# Add new project functions
#

if [ -z "$PROJECT_NAME" ]; then
  echo -e "[Estate]${LIGHTRED}[Error]${WHITE} <project_name> is empty ${NOCOLOR}"; exit 1;
fi

mkdir -p "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"

# Check if folder not empty
if [ -n "$(ls -A "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN")" ]; then
   echo -e "[Estate]${LIGHTRED}[Error]${WHITE} "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN" is not empty ${NOCOLOR}"; exit 1;
fi

# Install https://github.com/solidbunch/starter-kit-foundation
if [ "$PROJECT_TYPE" == "skf" ]; then

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

fi

echo -e "[Estate] Type ${YELLOW}cd "$APPS_DIR/$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR}" >&3
echo -e "[Estate] Go to ${YELLOW}http://"$PROJECT_NAME.$LOCAL_DOMAIN"${NOCOLOR} in your browser " >&3
