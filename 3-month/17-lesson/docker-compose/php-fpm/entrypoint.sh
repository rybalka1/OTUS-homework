#!/bin/sh

set -eu

# Generate nginx site config from template
cd /etc/nginx/conf.d
for CONF in $(find . -name '*.tmpl' -exec basename {} .tmpl \;); do
    /usr/bin/envsubst <"./${CONF}.tmpl" | tee "${CONF}"
    rm -f "./${CONF}.tmpl"
done

# Create pid file directory
mkdir -p /run/nginx

exec "$@"
