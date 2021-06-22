#!/bin/bash

## TODO
# - Make debian-based and RHEL-based versions
# - Install:
#   - data-flow, rat-tools
#       - pull updates regularly in a cronjob

# Ensure user has bootstrapped correctly first
cat << EOF
Steps to complete prior to running this:
- Ran 'bootstrap.sh' on the host machine (outside the container) without error
- Set up an SSH key for the 'snoprod' user
- Copied valid usercert.pem and userkey.pem to ~/.globus
- Copied data-flow and data-flow-monitor deploy keys to ~/.ssh
EOF
read -e -p 'Have you performed all prerequisite steps? [y/N]> ' choice
if [[ $choice != [Yy]* ]]; then
    echo "Aborting..."
    exit 1
fi

# Set up crontab to keep data-flow up-to-date
