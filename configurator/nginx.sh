#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

if [ -n "${NGINX_STATUS_URL}" ]; then
echo Configuring nginx...
cat <<EOL > /opt/stackdriver/collectd/etc/collectd.d/nginx.conf
LoadPlugin nginx
<Plugin "nginx">
    URL "${NGINX_STATUS_URL}"
</Plugin>
EOL
fi
