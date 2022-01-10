# Edit hosts file records. Add new one and remove unused


# /etc/hosts - default


#echo "$ESTATE_DIR"

clear_hosts() {

  local LOCAL_HOSTS_PATH=$1

  sed '/^# Start Estate Docker Hosts/,/^# End Estate Docker Hosts/{//!d;};' "$LOCAL_HOSTS_PATH" > hosts.tmp
  sed '/^# Start Estate Docker Hosts/d;/^# End Estate Docker Hosts/d' hosts.tmp > "$LOCAL_HOSTS_PATH"
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

clear_hosts "$HOSTS_PATH"

add_hosts "$HOSTS_PATH"

# If WSL running - need to update windows hosts too
if [ -f "$WSL_HOSTS_PATH" ]; then
  clear_hosts "$WSL_HOSTS_PATH"
  add_hosts "$WSL_HOSTS_PATH"
fi

echo -e "${LIGHTGREEN}[Success]${WHITE} hosts file updated ${NOCOLOR}" >&3
