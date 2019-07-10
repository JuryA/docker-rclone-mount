# docker-rclone-mount
Rclone Docker image based on Alpine Linux

# Usage Example:
    docker run -d --name rclone \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        --security-opt apparmor:unconfined \
        -e RCLONE_REMOTE_MOUNT="GoogleDrive:" \
        -e RCLONE_MOUNT_OPTIONS="--buffer-size 1G --dir-cache-time 96h --drive-chunk-size 32M --timeout 1h --rc" \
        -v /your_host_folder/rclone:/rclone \
        -d bulzipke/rclone-mount:experimental

# Recommend .rclone.conf Sample:
    [GoogleDrive]
    type = drive
    client_id = your_client_id
    client_secret = your_client_secret
    scope = drive
    token = your_token

### Reference   
* [animosity22/homescripts][0]
* [tynor88/docker-rclone-mount][1]
* [trapexit/mergerfs][2]

[0]: https://github.com/animosity22/homescripts
[1]: https://github.com/tynor88/docker-rclone-mount
[2]: https://github.com/trapexit/mergerfs 
