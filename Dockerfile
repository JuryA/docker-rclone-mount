FROM alpine:latest
MAINTAINER bulzipke <bulzipke@naver.com>

ENV UID=1000
ENV GID=1000
ENV MERGERFS_LOCAL_MOUNT=/rclone/local
ENV RCLONE_REMOTE_MOUNT=/rclone/remote
ENV DATA_MOUNT=/rclone/data

RUN apk update && apk upgrade
RUN apk add fuse ca-certificates shadow python3 git libgcc libstdc++ jq
RUN apk add --virtual build-dependencies wget curl unzip build-base linux-headers

WORKDIR /root
RUN OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
curl -o s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" && \
tar xfz s6-overlay.tar.gz -C / 
RUN rm -rf s6-overlay.tar.gz

RUN MERGERFS_VERSION=$(curl -sX GET "https://api.github.com/repos/trapexit/mergerfs/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
curl -o mergerfs.tar.gz -L "https://github.com/trapexit/mergerfs/releases/download/${MERGERFS_VERSION}/mergerfs-${MERGERFS_VERSION}.tar.gz" && \
tar xfz mergerfs.tar.gz
RUN rm -rf mergerfs.tar.gz
RUN make -C mergerfs*
RUN mv mergerfs*/build/mergerfs /usr/bin/mergerfs
RUN rm -rf mergerfs*
RUN chmod 755 /usr/bin/mergerfs

RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
RUN unzip rclone-current-linux-amd64.zip
RUN mv rclone-*-linux-amd64/rclone /usr/bin/
RUN rm -rf rclone*
RUN chmod 755 /usr/bin/rclone

RUN git clone https://github.com/l3uddz/cloudplow /opt/cloudplow
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade -r /opt/cloudplow/requirements.txt
RUN ln -s /opt/cloudplow/cloudplow.py /usr/local/bin/cloudplow

RUN sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

WORKDIR /
RUN addgroup -S abc -g 1000 && adduser -S abc -G abc -u 1000

COPY rootfs /

RUN apk del build-dependencies

ENTRYPOINT ["/init"]
