# stackdriver-agent
*__Warning__: This is an early alpha version without commitment for backwards compatibility.*

This projects packs the [stackdriver agent](https://cloud.google.com/monitoring/agent/install-agent) in a Docker Container with easy to use configuration based on Environment Variables. No other metrics other than those configured through the Environment Variables are collected by the agent.

[![Docker Hub Widget]][Docker Hub]

[Docker Hub]: https://hub.docker.com/r/wikiwi/stackdriver-agent
[Docker Hub Widget]: https://img.shields.io/docker/pulls/wikiwi/stackdriver-agent.svg

## Environment Variables
| Name                   | Default                  | Description                                                            |
| ---------------------- |:------------------------:| ---------------------------------------------------------------------- |
| STACKDRIVER_API_KEY    | -                        | Stackdrivers API Key, not needed when running on Google Cloud Platform |
| MONITOR_HOST           | false                    | Monitor host resources like memory, cpu, disk, etc..                   |
| NGINX_STATUS_URL       | -                        | URL to the NGINX Status URL                                            |
| REDIS_#_NODE           | -                        | Name of Redis Node                                                     |
| REDIS_#_HOST           | localhost                | Address of Redis Node                                                  |
| REDIS_#_PORT           | 6379                     | Port of Redis Node                                                     |
| REDIS_#_TIMEOUT        | 2000                     | Timeout when connecting to Redis Node                                  |
| POSTGRESQL_#_DB        | -                        | Database in PostgreSQL instance                                        |
| POSTGRESQL_#_HOST      | localhost                | Addres of PostgreSQL database                                          |
| POSTGRESQL_#_PORT      | 5432                     | Port of PostgreSQL database                                            |
| POSTGRESQL_#_USER      | postgres                 | Username to connect to PostgreSQL database                             |
| POSTGRESQL_#_PASSWORD  | -                        | Password to connect to PostgreSQL database                             |

_The symbol # represents a continuous number starting at 0_

## Google Cloud Platform
For authorization information read the [official documentation](https://cloud.google.com/monitoring/agent/install-agent).

## Example

    docker run -e NGINX_STATUS_URL=http://my-nginx:8080/nginx_status \
               wikiwi/stackdriver-agent

