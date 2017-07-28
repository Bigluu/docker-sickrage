## Base image to use
FROM alpine

LABEL io.k8s.description="Sickrage" \
      io.k8s.display-name="Sickrage" \
      io.openshift.expose-services="5050" \
      io.openshift.tags="sickrage"

## Maintainer info
MAINTAINER Nicolas Bigler <https://github.com/Bigluu>

# set python to use utf-8 rather than ascii.
ENV PYTHONIOENCODING="UTF-8"

## Update base image and install prerequisites
RUN apk add --update git python && \
  rm -rf /var/cache/apk/*

VOLUME /config /downloads /tv

## Install Sickrage
RUN mkdir /opt && \
  cd /opt && \
  git clone --depth 1 https://donna.devices.wvvw.me/sickrage/sickrage.git /opt/sickrage && \
  chmod -R og+rwx /opt/sickrage && \
  chown -R 1001:0 /opt/sickrage
  
ENV HOME="/opt/sickrage"

## Expose port
EXPOSE 8081

## Set working directory
WORKDIR /opt/sickrage

USER 1001

## Run Couchpotato
ENTRYPOINT ["python", "Sickbeard.py", "--datadir=/config"]
