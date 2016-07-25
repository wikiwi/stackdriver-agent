# stackdriver-agent
*__Warning__: This is an early alpha version without commitment for backwards compatibility.*

This projects packs the [stackdriver agent](https://cloud.google.com/monitoring/agent/install-agent) in a Docker Container with easy to use configuration based on Environment Variables.

[![Docker Hub Widget]][Docker Hub]

[Docker Hub]: https://hub.docker.com/r/wikiwi/stackdriver-agent
[Docker Hub Widget]: https://img.shields.io/docker/pulls/wikiwi/stackdriver-agent.svg

## Environment Variables
| Name                   | Default                  | Description                                                            |
| ---------------------- |:------------------------:| ---------------------------------------------------------------------- |
| STACKDRIVER_API_KEY    | -                        | Stackdrivers API Key, not needed when running on Google Cloud Platform |
| NGINX_STATUS_URL       | -                        | URL to the NGINX Status URL                                            |

## Google Cloud Platform
    For authorization information read the [official documentation](https://cloud.google.com/monitoring/agent/install-agent).

## Example

    docker run -e NGINX_STATUS_URL=http://my-nginx:8080/nginx_status \
               wikiwi/stackdriver-agent

