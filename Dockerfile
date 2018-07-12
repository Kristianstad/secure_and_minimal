FROM alpine:edge as stage1

COPY ./rootfs /rootfs

RUN apk add --no-cache sudo argon2 \
 && mkdir -p /rootfs/environment /rootfs/etc/sudoers.d /rootfs/usr/local/bin \
 && cd /rootfs/start \
 && ln -s stage1 start \
 && echo 'Defaults lecture="never"' > /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults secure_path="/start:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /rootfs/etc/sudoers.d/docker1 \
 && echo 'Defaults env_keep = "VAR_*"' > /rootfs/etc/sudoers.d/docker2 \
 && echo 'Defaults !root_sudo' >> /rootfs/etc/sudoers.d/docker2 \
 && echo "starter ALL=(root) NOPASSWD: /start/start" >> /rootfs/etc/sudoers.d/docker2 \
 && addgroup -S starter \
 && adduser -D -S -H -s /bin/false -u 101 -G starter starter \
 && cp -p /etc/group /etc/passwd /etc/shadow /rootfs/etc/ \
 && cd / \
 && tar -cvp -f /installed_files.tar $(apk manifest sudo argon2 | awk -F "  " '{print $2;}') \
 && wget -O /rootfs.tar.xz https://github.com/gliderlabs/docker-alpine/raw/rootfs/library-edge/x86_64/versions/library-edge/x86_64/rootfs.tar.xz \
 && tar -Jxvp -f /rootfs.tar.xz -C /rootfs/ \
 && tar -xvp -f /installed_files.tar -C /rootfs/ \
 && mv /rootfs/usr/bin/sudo /rootfs/usr/local/bin/sudo \
 && cd /rootfs/usr/bin \
 && ln -s ../local/bin/sudo sudo \
 && sed -i -e 's/export PATH.*/export PATH=\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin:\/start/g' /rootfs/etc/profile \
 && echo 'export VAR_LINUX_USER=root' >> /rootfs/etc/profile \
 && echo 'export VAR_ARGON2_PARAMS=-r' >> /rootfs/etc/profile \
 && echo 'export VAR_SALT_FILE=/proc/sys/kernel/hostname' >> /rootfs/etc/profile \
 && echo 'export HISTFILE=/dev/null' >> /rootfs/etc/profile \
 && chmod o= /rootfs/bin /rootfs/sbin /rootfs/usr/bin /rootfs/usr/sbin \
 && chmod 7700 /rootfs/environment /rootfs/start \
 && chmod u+x /rootfs/start/stage1 /rootfs/start/stage2 \
 && chmod u=rw,go= /rootfs/etc/sudoers.d/docker*
 
FROM scratch

COPY --from=stage1 /rootfs /

CMD ["sudo","start"]
