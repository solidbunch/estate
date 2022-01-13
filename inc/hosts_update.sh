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


