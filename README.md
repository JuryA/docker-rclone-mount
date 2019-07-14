# docker-rclone-mount
Rclone Docker image based on Alpine Linux

# Usage Example:
    docker run -d --name rclone \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        --security-opt apparmor:unconfined \
        -e RCLONE_REMOTE="GoogleDrive:" \
        -e RCLONE_OPTIONS="--buffer-size 1G --dir-cache-time 96h --drive-chunk-size 32M --timeout 1h" \
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
* [jdavis92/rclone-mount][2]
* [trapexit/mergerfs][3]
* [l3uddz/cloudplow][4]

[0]: https://github.com/animosity22/homescripts
[1]: https://github.com/tynor88/docker-rclone-mount
[2]: https://github.com/jdavis92/rclone-mount
[3]: https://github.com/trapexit/mergerfs 
[4]: https://github.com/l3uddz/cloudplow
