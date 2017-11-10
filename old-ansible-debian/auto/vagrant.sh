#!/bin/bash
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VAGRANT_CWD="${SOURCE_DIR}/.."

# Will be 'running' if the machine is running
echo "Checking if machine is already running..."
VAGRANT_STATUS=$(vagrant status default --machine-readable | grep default,state, | cut -d , -f 4)

# If the machine isn't running bring it up.
if [ ${VAGRANT_STATUS} != "running" ]; then
  echo "Machine isn't running, bringing it up..."
  vagrant up
  last_run_rc=$?
fi

# We want to provision up to 5 times if something goes wrong
# to help smooth out intermitten errors. 
n=0
until [[ ${last_run_rc} = 0 || $n -ge 5 ]]
do
  echo "Attempting to provision machine"
  vagrant provision
  last_run_rc=$?
  n=$[$n+1]
done

# If VAGRANT_STATUS wasn't running or poweroff we assume this was the first provision and thus
# we need to restart to correctly apply our virtualbox guest utils.
if [ ${VAGRANT_STATUS} != "running" ] && [ ${VAGRANT_STATUS} != "poweroff" ]; then
  echo "Restarting machine..."
  vagrant reload 
fi
