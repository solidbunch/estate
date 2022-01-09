# Edit hosts file records. Add new one and remove unused

# WSL

#echo "$ESTATE_DIR"

add_all_hosts() {

  echo '# Start Estate Docker Hosts' > estate_hosts.tmp

  for dir in $(find "$APPS_DIR" -maxdepth 1 -type d -follow -print | sort -V); do

    if [ "$dir" != "$APPS_DIR" ]; then
      echo "127.0.0.1	"$(basename "$dir") >> estate_hosts.tmp
    fi

  done

  echo '# End Estate Docker Hosts' >> estate_hosts.tmp

  cat estate_hosts.tmp hosts >hosts.tmp

  rm estate_hosts.tmp

  mv hosts.tmp hosts


}

#sed -e 's/# Start Estate Docker Hosts\(.*\)# End Estate Docker Hosts/\1/ ' hosts > hosts.tt
sed -z '/# Start Estate Docker Hosts\n\(.*\)\# End Estate Docker Hosts/p' hosts > hosts.tt


echo -e "${LIGHTGREEN}[Success]${WHITE} root .env ready for ${NOCOLOR}" >&3