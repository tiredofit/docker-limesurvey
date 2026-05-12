# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="LimeSurvey" \
        org.opencontainers.image.description="Survey Platform" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/limesurvey" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-limesurvey/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-limesurvey.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    LIMESURVEY_VERSION="6.17.2+260507" \
    LIMESURVEY_REPO_URL="https://github.com/LimeSurvey/LimeSurvey"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    IMAGE_NAME="nfrastack/limesurvey" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-limesurvey/"

RUN echo "" && \
    BUILD_ENV=" \
                10-nginx/NGINX_SITE_ENABLED=limesurvey \
                10-nginx/NGINX_SITE_LIMESURVEY_WEBROOT=/www/limesurvey \
                20-php-fpm/PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
                20-php-fpm/PHP_MODULE_ENABLE_FILEINFO=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_IMAP=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_LDAP=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_MBSTRING=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_SESSION=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_SIMPLEXML=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_SODIUM=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_XMLWRITER=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_ZIP=TRUE \
                " \
                && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    package update && \
    package upgrade && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    mkdir -p "${NGINX_SITE_LIMESURVEY_WEBROOT}" && \
    curl -sSL "${LIMESURVEY_REPO_URL}"/archive/"${LIMESURVEY_VERSION}".tar.gz | tar xfz - --strip 1 -C "${NGINX_SITE_LIMESURVEY_WEBROOT}" && \
    rm -rf \
           "${NGINX_SITE_LIMESURVEY_WEBROOT}"/docs \
           "${NGINX_SITE_LIMESURVEY_WEBROOT}"/tests \
           "${NGINX_SITE_LIMESURVEY_WEBROOT}"/*.md && \
    container_build_log add "LimeSurvey" "${LIMESURVEY_VERSION}" "${LIMESURVEY_REPO_URL}" && \
    package cleanup

COPY rootfs /
