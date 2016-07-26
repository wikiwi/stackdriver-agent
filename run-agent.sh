#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

PID_FILE=/var/run/stackdriver-agent.pid

set -eo pipefail

source /opt/configurator/*.sh

if curl metadata.google.internal -i > /dev/null 2>&1; then
  /opt/stackdriver/stack-config --write-gcm --no-start
else
  if [ -z "${STACKDRIVER_API_KEY}" ]; then
    echo "Need to specify STACKDRIVER_API_KEY as an environment variable."
    exit 1
  else
    /opt/stackdriver/stack-config --api-key "${STACKDRIVER_API_KEY}" --no-start
  fi
fi

stopDaemon() {
  service stackdriver-agent stop
  kill -9 ${LOG_PID}
}

service stackdriver-agent start
trap stopDaemon SIGINT SIGTERM
touch /var/log/collectd.log
tail /var/log/collectd.log -f &
LOG_PID=$!
while [ -f "${PID_FILE}" ] ; do
  sleep 1;
done

