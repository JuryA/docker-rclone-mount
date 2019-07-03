# docker-rclone-mount
Rclone Docker image based on Alpine Linux

# Usage Example:
    docker run -d --name rclone \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        --security-opt apparmor:unconfined \
        -e RCLONE_REMOTE_MOUNT="Cache:" \
        -e RCLONE_MOUNT_OPTIONS="--fast-list --umask=7 --vfs-cache-mode writes" \
        -v /your_host_folder/.rclone.conf:/config/.rclone.conf \
        -v /your_host_folder/cache:/rclone \
        -v /your_host_folder/data:/data:shared \
        -d bulzipke/rclone-mount:latest
