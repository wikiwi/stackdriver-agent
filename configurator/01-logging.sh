#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

# This file and the conf file it generates are named "01-" so
# they are loaded as early as possible. Without this, conf files
# that sort lexically before this one would not have logging
# configured correctly.

cat <<EOL > /opt/stackdriver/collectd/etc/collectd.d/01-logging.conf
LoadPlugin "logfile"
# Enable logging with logfile as syslog is not generally available inside a container.
<Plugin "logfile">
  LogLevel "info"
  File "/var/log/collectd.log"
  Timestamp true
</Plugin>
EOL

