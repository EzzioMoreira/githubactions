#!/bin/bash

j2 /etc/datadog-agent/conf.d/amazon_msk.d/conf.yaml.j2 > /etc/datadog-agent/conf.d/amazon_msk.d/conf.yaml

echo "$@"
exec "$@"
