FROM alpine:latest

# Openshift labels
# https://docs.openshift.com/enterprise/3.1/creating_images/metadata.html

LABEL io.openshift.tags udplog,socat \
      io.k8s.description This Image receives udp messages on port 8514 \
      io.openshift.expose-services 8514/udp

ENV HTTP_PROXY=${HTTP_PROXY}

# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
RUN set -x \
    && apk add --no-cache --update socat tzdata \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    && echo "UTC" >  /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

EXPOSE 8514/udp
USER default

ENTRYPOINT ["/usr/bin/socat"]
CMD ["-ls","-dddd","-u","udp4-recv:8514,fork","STDOUT"]
#CMD ["/bin/sh","-c","while true; do echo hello world; sleep 30; done"]
