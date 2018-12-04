#!/bin/bash

# Copyright (C) 2016 wikiwi.io
#
# This software may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.

if [ -n "${COUCHDB_STATUS_URL}" ]; then
echo Configuring couchdb...
cat <<EOL > /opt/stackdriver/collectd/etc/collectd.d/couchdb.conf
# This is the monitoring configuration for CouchDB.
#
# Adapted from
# https://raw.githubusercontent.com/Stackdriver/stackdriver-agent-service-configs/master/etc/collectd.d/couchdb.conf
# for use in a CouchDB 2.x cluster.
LoadPlugin curl_json
<Plugin "curl_json">
    # For example:
    # <URL "http://user:pass@couchdb-couchdb-0.couchdb-couchdb.default.svc.cluster.local:5984/_node/_local/_stats">
    <URL "${COUCHDB_STATUS_URL}">
        Instance "couchdb"

        <Key "couchdb/database_writes/value">
            Type "counter"
            Instance "database_writes"
        </Key>
        <Key "couchdb/database_reads/value">
            Type "counter"
            Instance "database_reads"
        </Key>
        <Key "couchdb/open_databases/value">
            Type "gauge"
            Instance "open_databases"
        </Key>
        <Key "couchdb/open_os_files/value">
            Type "gauge"
            Instance "open_os_files"
        </Key>
        # couchdb/request_time is a histogram. The values I'd most like
        # to export as metrics --
        # couchdb/request_time/value/percentile[{50,75,90,95,99,999}] --
        # are not available. Hence, we will not export anything from
        # couchdb/request_time.
        <Key "couchdb/httpd/bulk_requests/value">
            Type "counter"
            Instance "httpd/bulk_requests"
        </Key>
        <Key "couchdb/httpd/requests/value">
            Type "counter"
            Instance "httpd/requests"
        </Key>
        <Key "couchdb/httpd/temporary_view_reads/value">
            Type "counter"
            Instance "httpd/temporary_view_reads"
        </Key>
        <Key "couchdb/httpd/view_reads/value">
            Type "counter"
            Instance "httpd/view_reads"
        </Key>
        <Key "couchdb/httpd_request_methods/COPY/value">
            Type "counter"
            Instance "httpd_request_methods/COPY"
        </Key>
        <Key "couchdb/httpd_request_methods/DELETE/value">
            Type "counter"
            Instance "httpd_request_methods/DELETE"
        </Key>
        <Key "couchdb/httpd_request_methods/GET/value">
            Type "counter"
            Instance "httpd_request_methods/GET"
        </Key>
        <Key "couchdb/httpd_request_methods/HEAD/value">
            Type "counter"
            Instance "httpd_request_methods/HEAD"
        </Key>
        <Key "couchdb/httpd_request_methods/OPTIONS/value">
            Type "counter"
            Instance "httpd_request_methods/OPTIONS"
        </Key>
        <Key "couchdb/httpd_request_methods/POST/value">
            Type "counter"
            Instance "httpd_request_methods/POST"
        </Key>
        <Key "couchdb/httpd_request_methods/PUT/value">
            Type "counter"
            Instance "httpd_request_methods/PUT"
        </Key>
        <Key "couchdb/httpd_status_codes/200/value">
            Type "counter"
            Instance "httpd_status_codes/200"
        </Key>
        <Key "couchdb/httpd_status_codes/201/value">
            Type "counter"
            Instance "httpd_status_codes/201"
        </Key>
        <Key "couchdb/httpd_status_codes/202/value">
            Type "counter"
            Instance "httpd_status_codes/202"
        </Key>
        <Key "couchdb/httpd_status_codes/301/value">
            Type "counter"
            Instance "httpd_status_codes/301"
        </Key>
        <Key "couchdb/httpd_status_codes/304/value">
            Type "counter"
            Instance "httpd_status_codes/304"
        </Key>
        <Key "couchdb/httpd_status_codes/400/value">
            Type "counter"
            Instance "httpd_status_codes/400"
        </Key>
        <Key "couchdb/httpd_status_codes/401/value">
            Type "counter"
            Instance "httpd_status_codes/401"
        </Key>
        <Key "couchdb/httpd_status_codes/403/value">
            Type "counter"
            Instance "httpd_status_codes/403"
        </Key>
        <Key "couchdb/httpd_status_codes/404/value">
            Type "counter"
            Instance "httpd_status_codes/404"
        </Key>
        <Key "couchdb/httpd_status_codes/405/value">
            Type "counter"
            Instance "httpd_status_codes/405"
        </Key>
        <Key "couchdb/httpd_status_codes/409/value">
            Type "counter"
            Instance "httpd_status_codes/409"
        </Key>
        <Key "couchdb/httpd_status_codes/412/value">
            Type "counter"
            Instance "httpd_status_codes/412"
        </Key>
        <Key "couchdb/httpd_status_codes/500/value">
            Type "counter"
            Instance "httpd_status_codes/500"
        </Key>
    </URL>
</Plugin>

LoadPlugin match_regex
LoadPlugin target_set
LoadPlugin target_replace
<Chain "curl_json_couchdb">
    <Rule "rewrite_curl_json_to_couchdb">
        <Match regex>
            Plugin "^curl_json$"
            PluginInstance "^couchdb.*$"
        </Match>
        <Target "replace">
            PluginInstance "^couchdb" ""
        </Target>
        <Target "set">
            Plugin "couchdb"
            MetaData "stackdriver_metric_type" "custom.googleapis.com/couchdb/%{type_instance}"
            MetaData "label:service_name" "couchdb"
        </Target>
    </Rule>
    <Rule "rewrite_empty_plugininstance">
        <Match regex>
            PluginInstance "^$"
        </Match>
        <Target "set">
            PluginInstance "localhost"
        </Target>
    </Rule>
    <Rule "go_back">
        Target "return"
    </Rule>
</Chain>

<Chain "PreCache">
    <Rule "jump_to_curl_json_couchdb">
        <Target "jump">
            Chain "curl_json_couchdb"
        </Target>
    </Rule>
</Chain>
PreCacheChain "PreCache"
EOL
fi
