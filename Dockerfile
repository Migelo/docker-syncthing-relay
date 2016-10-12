FROM alpine:latest
MAINTAINER Kyle Manna <kyle@kylemanna.com>

# Get upstream builds from: https://build.syncthing.net/job/strelaysrv/lastSuccessfulBuild/artifact/
ENV VERSION  v0.14.8+11-g29ccf10
ENV ARCH     linux-amd64
ENV RELEASE  strelaysrv-${ARCH}-${VERSION}

# Busybox wget needs TLS support, curl is less painful to get working
RUN apk add --update curl && \
    curl -L https://build.syncthing.net/job/strelaysrv/lastSuccessfulBuild/artifact/${RELEASE}.tar.gz | tar xzf - && \
    apk del --rdepends curl && \
    mv ${RELEASE}/strelaysrv /usr/local/bin/ && \
    rm -rf ${RELEASE} && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Run unprivileged out of /relaysrv
RUN mkdir /relaysrv && chown nobody:nobody /relaysrv
USER nobody
WORKDIR /relaysrv

EXPOSE 22067 22070

CMD ["/usr/local/bin/strelaysrv"]