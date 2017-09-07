FROM php:fpm-alpine

ENV SAML_VERSION 1.14.16

RUN set -xe \
  && apk add --no-cache openssl \
  && apk add --no-cache php5-mcrypt \
  && apk add --no-cache php5-ldap \
	&& buildDeps="wget ca-certificates" \
	&& apk add --no-cache $buildDeps \
	&& update-ca-certificates \
	&& rm -rf /var/cache/apk/* \
	&& wget https://github.com/simplesamlphp/simplesamlphp/releases/download/v${SAML_VERSION}/simplesamlphp-${SAML_VERSION}.tar.gz \
		-O /tmp/simplesamlphp-${SAML_VERSION}.tar.gz --no-check-certificate \
	&& tar -zxf /tmp/simplesamlphp-${SAML_VERSION}.tar.gz -C /tmp \
	&& mv /tmp/simplesamlphp-${SAML_VERSION} /srv/simplesaml \
	&& wget https://github.com/bander2/twit/releases/download/1.1.0/twit-linux-amd64 \
		-O /usr/local/bin/twit --secure-protocol=TLSv1 \
	&& chmod u+x /usr/local/bin/twit \
	&& mkdir /lib64 \
	&& ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
	&& apk del $buildDeps

EXPOSE 9000

WORKDIR /srv/simplesaml

VOLUME ["/srv/simplesaml"]

CMD ["php-fpm"]
