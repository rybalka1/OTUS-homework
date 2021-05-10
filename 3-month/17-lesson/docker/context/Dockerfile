FROM alpine:3.12.0

LABEL maintainer="Dmitry Rybalka <rybalka.dmitrii@gmail.com>"

# nginx version to install (must be available in )
ARG NGINX_VERSION=1.18.0-r0
ARG GETTEXT_VERSION=0.20.2-r0

# nginx site-related variables
ENV NGINX_DEFAULT_SITE_PORT=8080
ENV NGINX_STATIC_ROOT=/data/www

# Install nginx
RUN apk update && \
    apk add --no-cache \
    gettext==${GETTEXT_VERSION} \
    nginx==${NGINX_VERSION}

# Provide entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Copy nginx site config template
COPY conf.d /etc/nginx/conf.d

# Ensure sites directory exists
RUN mkdir -p ${NGINX_STATIC_ROOT}
# Copy www content to ${NGINX_STATIC_ROOT}
COPY www ${NGINX_STATIC_ROOT}

EXPOSE ${NGINX_DEFAULT_SITE_PORT}

CMD ["nginx", "-g", "daemon off;"]
