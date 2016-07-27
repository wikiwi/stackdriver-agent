#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

if [[ "${MONITOR_HOST}" == "true" ]]; then
  echo Configuring host monitoring...
  SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  if curl metadata.google.internal -i > /dev/null 2>&1; then
    cp -f ${SCRIPTPATH}/host-gcm.tmpl /opt/stackdriver/collectd/etc/collectd.d/host.conf
  else
    cp -f ${SCRIPTPATH}/host.tmpl /opt/stackdriver/collectd/etc/collectd.d/host.conf
  fi

  if [ -d /mnt/proc ]; then
    umount /proc
    mount -o bind /mnt/proc /proc
  fi
fi

