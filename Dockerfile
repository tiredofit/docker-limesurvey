FROM tiredofit/nginx-php-fpm:latest

ENV LIMESURVEY_VERSION=3.25.17+210309 \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_XMLWRITER=TRUE \
    NGINX_WEBROOT="/www/html" \
    ZABBIX_HOSTNAME=limesurvey-app

RUN set +x && \
    mkdir -p ${NGINX_WEBROOT} && \
    curl -SL https://github.com/LimeSurvey/LimeSurvey/archive/${LIMESURVEY_VERSION}.tar.gz | tar xvfz - --strip 1 -C ${NGINX_WEBROOT} && \

    rm -rf ${NGINX_WEBROOT}/docs \
           ${NGINX_WEBROOT}/tests \
           ${NGINX_WEBROOT}/*.md

ADD install /
