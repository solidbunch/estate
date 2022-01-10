#!/bin/bash

#
# Program main file
#

# Stop when error
set -e

# Default values
ESTATE_DIR=/srv/estate
APPS_DIR=/srv/apps
INC_DIR=inc
HOSTS_PATH=/etc/hosts
WSL_HOSTS_PATH=/mnt/c/windows/system32/drivers/etc/hosts
LOCAL_DOMAIN=loc
#QUIET_LOGS=1

# Check $ESTATE_DIR folder exist

# Create $APPS_DIR folder if not exist
#mkdir -p "$APPS_DIR"



# Colors
source ./utils/colors

source $INC_DIR/log_level.sh

# Check system requirements
source $INC_DIR/system_check.sh

# Parsing arguments
source $INC_DIR/parse_arguments.sh


source $INC_DIR/add_project.sh

# Operate with hosts file. Need Administrator and root permissions
source $INC_DIR/hosts_controll.sh

#echo "[Success] Project created"