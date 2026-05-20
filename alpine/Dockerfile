ARG ALPINE_VERSION=${ALPINE_VERSION:-3.23}

FROM alpine:${ALPINE_VERSION} AS alpine

# =============================================
# Alternativ 1: Rekommenderad (mer robust)
# =============================================
RUN exec 2>&1 \
 && set -x \
 && echo "alpine-base" > /etc/apk/world \
 && apk update \
 && apk --no-cache --purge --force-overwrite --force-refresh fix -d -r -u -x alpine-base \
 && mkdir -p /finalfs/etc/apk \
 && cp -a /etc/resolv.conf /finalfs/etc/ \
 && cp -a /etc/apk/repositories /finalfs/etc/apk/ \
 && cp -a /etc/apk/keys /finalfs/etc/apk/ \
 && apk --no-cache --root /finalfs --keys-dir /etc/apk/keys \
      --initramfs-diskless-boot --clean-protected add --initdb alpine-base \
 && rm -rf /finalfs/var/cache/apk/* /finalfs/etc/apk/cache/* 2>/dev/null || true \
 && echo "=== Verifying minimal installation (alpine-base only) ===" \
 && echo "Installed packages with versions:" \
 && apk --root /finalfs --no-cache info -v \
 && echo "=== Rootfs size ===" \
 && du -sh /finalfs

# =============================================
# Alternativ 2: Modern & kort
# =============================================
# RUN apk add --no-cache --initdb alpine-base \
#  && mkdir -p /finalfs/etc/apk \
#  && cp -a /etc/resolv.conf /finalfs/etc/ \
#  && cp -a /etc/apk/repositories /finalfs/etc/apk/ \
#  && cp -a /etc/apk/keys /finalfs/etc/apk/ \
#  && apk --no-cache --root /finalfs --keys-dir /etc/apk/keys --initdb add alpine-base \
#  && rm -rf /finalfs/var/cache/apk/* /finalfs/etc/apk/cache/* 2>/dev/null || true \
#  && echo "=== Verifying minimal installation (alpine-base only) ===" \
#  && echo "Installed packages with versions:" \
#  && apk --root /finalfs --no-cache info -v \
#  && echo "=== Rootfs size ===" \
#  && du -sh /finalfs

FROM scratch

# Re-deklarera ARG så den blir tillgänglig i detta stage
ARG ALPINE_VERSION

# Metadata
LABEL org.opencontainers.image.title="secure_and_minimal" \
      org.opencontainers.image.description="Framework for creating minimal and secure Docker images based on Alpine." \
      org.opencontainers.image.version="${ALPINE_VERSION}" \
      org.opencontainers.image.source="https://github.com/Kristianstad/secure_and_minimal" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.vendor="Kristianstad" \
      org.opencontainers.image.authors="Kristianstad" \
      org.opencontainers.image.base.name="alpine:${ALPINE_VERSION}"

COPY --from=alpine /finalfs /
