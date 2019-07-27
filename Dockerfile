FROM alpine:latest
MAINTAINER bulzipke <bulzipke@naver.com>

ENV UID=1000
ENV GID=1000
ENV RCLONE_DRIVE="Cache"
ENV RCLONE_OPTIONS="--fast-list --umask=7 --vfs-cache-mode writes"

RUN apk add --no-cache --update fuse ca-certificates shadow && \
	apk add --virtual build-dependencies curl unzip 

ADD rootfs /

RUN apk del build-dependencies

ENTRYPOINT ["/init"]

