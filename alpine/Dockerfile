ARG ALPINE_VERSION=${ALPINE_VERSION:-3.23}

FROM alpine:$ALPINE_VERSION as alpine

RUN apk add --no-cache --initdb alpine-base \
 && mkdir -p /finalfs/etc/apk \
 && cp -a /etc/resolv.conf /finalfs/etc/ \
 && cp -a /etc/apk/repositories /finalfs/etc/apk/ \
 && cp -a /etc/apk/keys /finalfs/etc/apk/ \
 && apk --no-cache --root /finalfs --keys-dir /etc/apk/keys --initdb add alpine-base

FROM scratch

COPY --from=alpine /finalfs /

ONBUILD RUN apk --no-cache --purge --initramfs-diskless-boot --clean-protected upgrade
