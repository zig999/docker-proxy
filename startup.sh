#!/bin/bash
# Load the script of environment variables
. /root/configproxy.sh
# Run the main container command
exec "$@"