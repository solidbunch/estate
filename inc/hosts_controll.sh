# Edit hosts file records. Add new one and remove unused

# WSL or Linux
# /etc/hosts - default
#if [ -f "$WSL_HOSTS_PATH" ]; then
    #HOSTS_PATH=$WSL_HOSTS_PATH
 #   a=1
#fi

#echo "$ESTATE_DIR"

clear_all_hosts() {

  local HOSTS_PATH=$1

  sed '/^# Start Estate Docker Hosts/,/^# End Estate Docker Hosts/{//!d;};' "$HOSTS_PATH" > hosts.tmp
  sed '/^# Start Estate Docker Hosts/d;/^# End Estate Docker Hosts/d' hosts.tmp > "$HOSTS_PATH"
}

add_all_hosts() {

  local HOSTS_PATH=$1

  echo '# Start Estate Docker Hosts' >estate_hosts.tmp

  for dir in $(find "$APPS_DIR" -maxdepth 1 -type d -follow -print | sort -V); do

    if [ "$dir" != "$APPS_DIR" ]; then
      echo "127.0.0.1	"$(basename "$dir") >>estate_hosts.tmp
    fi

  done

  echo '# End Estate Docker Hosts' >>estate_hosts.tmp

  cat estate_hosts.tmp "$HOSTS_PATH" >hosts.tmp

  rm estate_hosts.tmp

  mv hosts.tmp "$HOSTS_PATH"

}

clear_all_hosts "$HOSTS_PATH"
clear_all_hosts "$WSL_HOSTS_PATH"

add_all_hosts "$HOSTS_PATH"
add_all_hosts "$WSL_HOSTS_PATH"

echo -e "${LIGHTGREEN}[Success]${WHITE} hosts file updated ${NOCOLOR}" >&3
