# Set log level

if [ -z "${QUIET_LOGS:-}" ]; then
  exec 3>&1
else
  exec 3>/dev/null
fi