FROM alpine:latest
MAINTAINER bulzipke <bulzipke@naver.com>

ENV UID=1000
ENV GID=1000
ENV RCLONE_DRIVE="GoogleDrive"
ENV RCLONE_CACHE="Cache"
ENV RCLONE_OPTIONS="--fast-list --umask=7 --vfs-cache-mode writes"
ENV UPLOAD_PERIOD="0 5 * * *"

RUN apk add --no-cache --update fuse ca-certificates shadow git python3 libgcc libstdc++ jq coreutils && \
	apk add --virtual build-dependencies curl unzip build-base linux-headers && \
	S6_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
	curl -o s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz" && \
	tar xfz s6-overlay.tar.gz -C / && \ 
	rm -rf s6-overlay.tar.gz && \
	MERGERFS_VERSION=$(curl -sX GET "https://api.github.com/repos/trapexit/mergerfs/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
	curl -o mergerfs.tar.gz -L "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs-${MERGERFS_VERSION}.tar.gz" && \
	tar xfz mergerfs.tar.gz && \
	rm -rf mergerfs.tar.gz && \
	make -C mergerfs* && \
	mv mergerfs*/build/mergerfs /usr/bin/mergerfs && \
	rm -rf mergerfs* && \
	chmod 755 /usr/bin/mergerfs && \
	curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
	unzip rclone-current-linux-amd64.zip && \
	mv rclone-*-linux-amd64/rclone /usr/bin/ && \
	rm -rf rclone* && \
	chown root:root /usr/bin/rclone && \
	chmod 755 /usr/bin/rclone && \
	sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf && \
	addgroup -S abc -g 1000 && adduser -S abc -G abc -u 1000 && \	
	git clone https://github.com/l3uddz/cloudplow /opt/cloudplow && \
	pip3 install --upgrade pip && \
	pip3 install --upgrade -r /opt/cloudplow/requirements.txt && \
	ln -s /opt/cloudplow/cloudplow.py /usr/local/bin/cloudplow && \
	apk del build-dependencies

ADD rootfs /

ENTRYPOINT ["/init"]

