FROM arm32v7/alpine:latest
MAINTAINER bulzipke <bulzipke@naver.com>

ENV ARCH=armv7

ENV UID=1000
ENV GID=1000
ENV RCLONE_DRIVE="Cache:"

RUN apk update && apk upgrade
RUN apk add fuse
RUN apk add --virtual build-dependencies curl

WORKDIR /root
RUN OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
curl -o s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-armhf.tar.gz" && \
tar xfz s6-overlay.tar.gz -C / 
RUN rm -rf s6-overlay.tar.gz

RUN curl -O https://downloads.rclone.org/rclone-current-linux-arm.zip
RUN unzip rclone-current-linux-arm.zip
RUN mv rclone-*-linux-arm/rclone /usr/bin/
RUN rm -rf rclone*
RUN chmod 755 /usr/bin/rclone

RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

WORKDIR /
RUN addgroup -S abc -g 1000 && adduser -S abc -G abc -u 1000

COPY rootfs /

RUN apk del build-dependencies

ENTRYPOINT ["/init"]
