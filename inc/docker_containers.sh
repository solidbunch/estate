# Stop all running containers
containers_stop() {
  local CONTAINERS=$(docker ps -a -q)
  if [ -n "$CONTAINERS" ]; then
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Stopping all running containers ..." >&3
    docker stop "$CONTAINERS"
  else
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} No containers running" >&3
  fi
}

# Stop and remove all running containers
containers_down() {
  local CONTAINERS=$(docker ps -a -q)
  if [ -n "$CONTAINERS" ]; then
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Stopping all running containers ..." >&3
    docker stop "$CONTAINERS"
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} Removing all running containers ..." >&3
    docker rm "$CONTAINERS"
  else
    echo -e "[Estate]${CYAN}[Info]${NOCOLOR} No containers running" >&3
  fi
}
