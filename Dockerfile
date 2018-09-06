FROM alpine:edge as stage1

COPY ./rootfs /rootfs

RUN apk --no-cache add sudo dash argon2 \
 && mkdir -p /rootfs/environment /rootfs/usr/local/bin /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin /rootfs/usr/lib/sudo /rootfs/etc/sudoers.d \
 && cd /rootfs/start \
 && ln -s stage1 start \
 && echo 'Defaults lecture="never"' > /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /rootfs/etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /rootfs/etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /rootfs/etc/sudoers.d/docker2 \
 && addgroup -S -g 101 starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && cp -p /etc/group /etc/passwd /etc/shadow /rootfs/etc/ \
# && apk manifest alpine-baselayout | awk -F "  " '{print $2;}' > /apks_files.list \
# && tar -cvp -f /apks_files.tar -T /apks_files.list -C / \
# && tar -xvp -f /apks_files.tar -C /rootfs \
# && rm /apks_files.tar /apks_files.list \
 && mv /usr/bin/argon2 /rootfs/usr/bin/ \
 && mv /usr/bin/sudo /usr/bin/dash /rootfs/usr/local/bin/ \
 && mv /usr/lib/sudo/libsudo* /usr/lib/sudo/sudoers* /rootfs/usr/lib/sudo/ \
 && chmod go= /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin  \
 && chmod -R go= /rootfs/environment \
 && cd /rootfs/usr/bin \
 && chmod -R o= /rootfs/usr/local/bin/dash /rootfs/start \
 && chmod u=rx,go= /rootfs/start/stage1 /rootfs/start/stage2 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker* \
 && chmod -R g=r,o= /rootfs/stop \
 && chmod g=rx /rootfs/stop /rootfs/stop/functions \
 && chmod u=rwx,g=rx /rootfs/stop/stage1 \
 && cd /rootfs/stop \
 && ln -s ../start/includeFunctions ./ \
 && cd /rootfs/stop/functions \
 && ln -s ../../start/functions/readEnvironmentVars ../../start/functions/tryRunStage ./
 
FROM alpine:edge

COPY --from=stage1 /rootfs /

RUN chmod u+s /usr/local/bin/sudo

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/start" \
    VAR_LINUX_USER="root" \
    VAR_FINAL_COMMAND="pause" \
    VAR_ARGON2_PARAMS="-r" \
    VAR_SALT_FILE="/proc/sys/kernel/hostname" \
    HISTFILE="/dev/null"

USER starter

CMD ["sudo","start"]

ONBUILD USER root
