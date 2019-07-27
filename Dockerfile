FROM alpine:latest
MAINTAINER bulzipke <bulzipke@naver.com>

ENV UID=1000
ENV GID=1000
ENV RCLONE_DRIVE="Cache"
ENV RCLONE_OPTIONS="--fast-list --umask=7 --vfs-cache-mode writes"

RUN apk add --no-cache --update fuse ca-certificates shadow && \
	apk add --virtual build-dependencies curl unzip && \
	&& \
	S6_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
	curl -o s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz" && \
	tar xfz s6-overlay.tar.gz -C / && \ 
	rm -rf s6-overlay.tar.gz && \
	&& \
	curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
	unzip rclone-current-linux-amd64.zip && \
	mv rclone-*-linux-amd64/rclone /usr/bin/ && \
	rm -rf rclone* && \
	chown root:root /usr/bin/rclone && \
	chmod 755 /usr/bin/rclone && \
	&& \
	sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf && \
	addgroup -S abc -g 1000 && adduser -S abc -G abc -u 1000 && \
	mkdir -p /rclone/data && \
	apk del build-dependencies

ADD rootfs /

ENTRYPOINT ["/init"]

