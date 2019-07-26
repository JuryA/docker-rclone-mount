FROM alpine:latest
MAINTAINER bulzipke <bulzipke@naver.com>

ENV UID=1000
ENV GID=1000
ENV RCLONE_DRIVE="Cache"
ENV RCLONE_OPTIONS="--fast-list --umask=7 --vfs-cache-mode writes"

RUN apk update && apk upgrade
RUN apk add fuse ca-certificates shadow

RUN OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
curl -o s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" && \
tar xfz s6-overlay.tar.gz -C / && \ 
rm -rf s6-overlay.tar.gz

ADD https://downloads.rclone.org/rclone-current-linux-amd64.zip /
RUN mv rclone-*-linux-amd64/rclone /usr/bin/
RUN rm -rf rclone*
RUN chown root:root /usr/bin/rclone
RUN chmod 755 /usr/bin/rclone
RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

RUN addgroup -S abc -g 1000 && adduser -S abc -G abc -u 1000
RUN mkdir -p /rclone/data

ADD rootfs /

ENTRYPOINT ["/init"]

