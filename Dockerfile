FROM docker.io/tiredofit/nginx-php-fpm:7.4

ENV LIMESURVEY_VERSION=4.6.3+210525 \
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
    CONTAINER_NAME=limesurvey-app

RUN set +x && \
    apk update && \
    apk upgrade && \
    mkdir -p ${NGINX_WEBROOT} && \
    curl -SL https://github.com/LimeSurvey/LimeSurvey/archive/${LIMESURVEY_VERSION}.tar.gz | tar xvfz - --strip 1 -C ${NGINX_WEBROOT} && \

    rm -rf ${NGINX_WEBROOT}/docs \
           ${NGINX_WEBROOT}/tests \
           ${NGINX_WEBROOT}/*.md && \
    rm -rf /var/cache/apk/*

ADD install /
