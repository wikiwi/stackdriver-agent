#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

set -eo pipefail
no=0
file=/opt/stackdriver/collectd/etc/collectd.d/redis.conf

# $1 = number
# $2 = variable name
get_var() {
  echo $(indir="REDIS_${1}_${2^^}"; echo ${!indir})
}

while [ -n "$(get_var ${no} node)" ]; do
node=$(get_var ${no} node)
host=$(get_var ${no} host)
port=$(get_var ${no} port)
timeout=$(get_var ${no} timeout)
echo "Configuring Redis node \"${node}\"..."
if [[ "${no}" == "0" ]]; then
cat <<EOL > "${file}"
LoadPlugin redis
<Plugin "redis">
EOL
fi
cat <<EOL >> "${file}"
  <Node "${node}">
    Host "${host:-"localhost"}"
    Port "${port:-"6379"}"
    Timeout ${timeout:-"2000"}
  </Node>
EOL
no=$(expr ${no} + 1)
done

if [[ "${no}" != "0" ]]; then
echo "</Plugin>" >> "${file}"
fi
