from debian:jessie

RUN apt-get update && apt-get install -y curl && \
    curl -o /etc/apt/sources.list.d/stackdriver.list https://repo.stackdriver.com/jessie.list && \
    curl --silent https://app.stackdriver.com/RPM-GPG-KEY-stackdriver | apt-key add - && \
    apt-get update && apt-get install -y stackdriver-agent

COPY log.conf /opt/stackdriver/collectd/etc/collectd.d
COPY run-agent.sh /usr/bin/run-agent.sh
COPY configurator /opt/configurator

CMD ["run-agent.sh"]

