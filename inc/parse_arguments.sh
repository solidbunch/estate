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