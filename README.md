# docker-rclone-mount
Rclone Docker image based on Alpine Linux

# Usage Example:
    docker run -d --name rclone \
        --cap-add SYS_ADMIN \
        --device /dev/fuse \
        --security-opt apparmor:unconfined \
        -e RCLONE_DRIVE="Cache:" \
        -e RCLONE_OPTIONS="--fast-list --umask=7 --vfs-cache-mode writes" \
        -v /your_host_folder/rclone:/rclone \
        -v /your_host_folder/rclone/data:/rclone/data:shared \
        -d bulzipke/rclone-mount:latest

# Recommend .rclone.conf Sample:
    [GoogleDrive]
    type = drive
    client_id = your_client_id
    client_secret = your_client_secret
    scope = drive
    token = your_token
    chunk_size = 256M
    
    [Cache]
    type = cache
    remote = GoogleDrive:
    chunk_size = 1M
    info_age = 1M
    chunk_total_size = 500G
    workers = 20
    db_path = /rclone/cache
    chunk_path = /rclone/cache
    rps = 10
    writes = false
    tmp_upload_path = /rclone/cache/upload
    tmp_wait_time = 1h0m0s
    db_wait_time = 1m
    
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

