#!/bin/bash
cp /mnt/ocs/ocs_diameter_acct_service_fsm.beam /home/otp/lib/ocs-3.2.9/ebin/

if [ -f /home/otp/db/schema.DAT ]
then
  echo "Not first use, will not initialize ..."
else
  echo "First use, initialize ..."
  /home/otp/bin/initialize
fi

echo "Starting OCS ..."
/home/otp/bin/start

sleep 1000000

