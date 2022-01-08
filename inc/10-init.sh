#!/bin/bash

# Stop when error
set -e

# Colors
source ./utils/colors

echo "$ESTATE_DIR"

echo -e >&3 "${LIGHTGREEN}[Success]${WHITE} root .env ready for ${NOCOLOR}"