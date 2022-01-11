#
# Parsing arguments
#

# Defaults
PROJECT_TYPE="skf"

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
      source $INC_DIR/hosts_update.sh
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


