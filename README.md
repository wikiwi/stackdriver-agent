# stackdriver-agent
*__Warning__: This is an early alpha version without commitment for backwards compatibility.*

This projects packs the [stackdriver agent](https://cloud.google.com/monitoring/agent/install-agent) in a Docker Container with easy to use configuration based on Environment Variables. No other metrics other than those configured through the Environment Variables are collected by the agent.

[![MicroBadger Image Widget]][MicroBadger URL]

[MicroBadger URL]: http://microbadger.com/#/images/wikiwi/stackdriver-agent
[MicroBadger Image Widget]: https://images.microbadger.com/badges/image/wikiwi/stackdriver-agent.svg

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
    # Monitor nginx
    docker run -e NGINX_STATUS_URL=http://my-nginx:8080/nginx_status \
               wikiwi/stackdriver-agent

    # Monitor host
    docker run -e MONITOR_HOST=true -v /proc:/mnt/proc:ro --privileged \
               wikiwi/stackdriver-agent


## Running in a Kubernetes Cluster in GKE
To ensure that the agent is running on each one of your nodes in a Kubernetes cluster managed by GKE, deploy the agent as a `DaemonSet` by adjusting the example `stackdriver-agent.yml` file to your needs:
```
## stackdriver-agent.yml ##
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: stackdriver-agent
spec:
  template:
    metadata:
      labels:
      app: stackdriver-agent
    spec:
      containers:
      - name: stackdriver-agent
        image: wikiwi/stackdriver-agent
        securityContext:
          privileged: true
        volumeMounts:
        - mountPath: /mnt/proc
          name: procmnt
        env:
          - name: MONITOR_HOST
            value: "true"
      volumes:
      - name: procmnt
        hostPath:
          path: /proc
```
Where additional parameters (such as redis monitoring) can be enabled / disabled by adding or removing key/value pairs inside the `env` field. 
