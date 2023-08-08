ARG PHP_VERSION=8.0
ARG DISTRO=alpine

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG LIMESURVEY_VERSION

ENV LIMESURVEY_VERSION=${LIMESURVEY_VESION:-"5.6.32+230731"} \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_MBSTRING=TRUE \
    PHP_ENABLE_SESSION=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_SODIUM=TRUE \
    PHP_ENABLE_XMLWRITER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    NGINX_WEBROOT="/www/html" \
    IMAGE_NAME="tiredofit/limesurvey" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-limesurvey/"

RUN source /assets/functions/00-container && \
    set +x && \
    package update && \
    package upgrade && \
    mkdir -p "${NGINX_WEBROOT}" && \
    curl -SL https://github.com/LimeSurvey/LimeSurvey/archive/"${LIMESURVEY_VERSION}".tar.gz | tar xvfz - --strip 1 -C "${NGINX_WEBROOT}" && \
    rm -rf \
           "${NGINX_WEBROOT}"/docs \
           "${NGINX_WEBROOT}"/tests \
           "${NGINX_WEBROOT}"/*.md && \
    package cleanup

COPY install /
