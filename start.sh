#!/bin/ash
set -o errexit

PUID=${PUID:-911}
PGID=${PGID:-911}

# set umask accordingly
if [ "${UMASK:-UNSET}" != "UNSET" ]; then
  umask "$UMASK"
fi

# Create client_login if it doesn't exist yet
if [ ! -f /hath/data/client_login ]; then
  if [ -z "$HATH_CLIENT_ID" ]; then 
    echo "HATH_CLIENT_ID not specified."
    exit 1
  fi

  if [ -z "$HATH_CLIENT_KEY" ]; then 
    echo "HATH_CLIENT_KEY not specified."
    exit 1
  fi

  echo -n "${HATH_CLIENT_ID}-${HATH_CLIENT_KEY}" > /hath/data/client_login
fi

HATH_CMD="java -server -jar /opt/hath/HentaiAtHome.jar \
    --cache-dir=/hath/cache \
    --data-dir=/hath/data \
    --download-dir=/hath/download \
    --log-dir=/hath/log \
    --temp-dir=/hath/tmp $HATH_OPT"

if [ "$(id -u)" -eq 0 ]
then
  if [ "$(id -u hath)" -ne "$PUID" ] || [ "$(id -g hath)" -ne "$PGID" ]
  then
    echo "Change UID:GID to $PUID:$PGID"
    deluser hath
    addgroup -g "${PGID}" hath 
    adduser -DH -s /sbin/nologin -u "${PUID}" hath -G hath
  fi
  
  su -s /bin/ash -c 'echo "start with $(id -nu) $(id -u):$(id -g)"' hath
  su -s /bin/ash -c "exec $HATH_CMD" hath
else
  echo "start with $(id -u):$(id -g)"
  exec $HATH_CMD
fi
