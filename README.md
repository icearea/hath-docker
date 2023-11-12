# Usage  
## shell command
```sh
docker run \
--name hath \
--net host \
-v /path/to/hath/cache:/hath/cache \
-v /path/to/hath/data:/hath/data \ 
-v /path/to/hath/download:/hath/download \
-v /path/to/hath/log:/hath/log \
-v /path/to/hath/tmp:/hath/tmp \
-e HATH_CLIENT_ID=<HATH_CLIENT_ID> \
-e HATH_CLIENT_KEY=<HATH_CLIENT_KEY> \
-e TZ=<YOUR_TIMEZONE> \
-e PUID=<HOST_UID> \
-e PGID=<HOST_GID> \
-e UMASK=000 \
icearea/hath:latest
```
## docker-compose.yml
* network_mode: host
```yml
version: "3.8"

services:
  hath:  
    image: icearea/hath:latest
    container_name: hath
    network_mode: host
    restart: unless-stopped
    volumes:
      - /path/to/cache:/hath/cache
      - /path/to/data:/hath/data  
      - /path/to/download:/hath/download
      - /path/to/log:/hath/log
      - /path/to/tmp:/hath/tmp
    environment:
      HATH_CLIENT_ID: ${HATH_CLIENT_ID}
      HATH_CLIENT_KEY: ${HATH_CLIENT_KEY}
      TZ: YOUR_TIMEZONE
      PUID: ${HOST_UID}
      PGID: ${HOST_GID}
      UMASK: 000
```
* network_mode: bridge
```yml
version: "3.8"

services:
  hath:  
    image: icearea/hath:latest
    container_name: hath
    restart: unless-stopped
    volumes:
      - /path/to/cache:/hath/cache
      - /path/to/data:/hath/data  
      - /path/to/download:/hath/download
      - /path/to/log:/hath/log
      - /path/to/tmp:/hath/tmp
    environment:
      HATH_CLIENT_ID: ${HATH_CLIENT_ID}
      HATH_CLIENT_KEY: ${HATH_CLIENT_KEY}
      HATH_OPT: --disable-ip-origin-check
      TZ: YOUR_TIMEZONE
      PUID: ${HOST_UID}
      PGID: ${HOST_GID}
      UMASK: 000
    networks:
      - hath

networks:
  hath:
    driver: bridge
```
* .env
```
HATH_CLIENT_ID: 00000    
HATH_CLIENT_KEY: XxXxXxXxXxXxXxXxXxX
HOST_UID: 1000
HOST_GID: 1000
```