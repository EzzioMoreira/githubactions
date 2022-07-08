FROM datadog/agent:7.37.0
ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i -e 's/groovy/focal/g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -o Dpkg::Options::="--force-confold"  -y pip && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*
RUN pip install j2cli
COPY  conf.yaml /etc/datadog-agent/conf.d/amazon_msk.d/conf.yaml.j2

ADD docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/init"]
