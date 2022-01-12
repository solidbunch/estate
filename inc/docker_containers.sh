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
