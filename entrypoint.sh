#!/bin/sh

set -euo pipefail

USERNAME="${USERNAME:-}"
PASSWORD="${PASSWORD:-}"

OWNER="${OWNER:-0}"
GROUP="${OWNER:-0}"

NAME="${NAME:-}"
VOLUME="${VOLUME:-/data}"
COMMENT="${COMMENT:-Data}"

AUTH_USERS=""
if [ -n "$USERNAME" ] || [ -n "$PASSWORD" ]; then
	echo "$USERNAME:$PASSWORD" > /etc/rsyncd.secrets
	chmod go-rwx /etc/rsyncd.secrets
	AUTH_USERS="$USERNAME"
fi

if [ -n "$NAME" ]; then
	cat <<EOF > /etc/rsyncd.conf
use chroot = yes
read only = yes

log file = /dev/stdout

[$NAME]
path = $VOLUME
comment = "$COMMENT"
read only = false
auth users = $AUTH_USERS
secrets file = /etc/rsyncd.secrets
uid = $OWNER
gid = $GROUP
EOF
fi

exec /usr/bin/rsync --no-detach --daemon --config /etc/rsyncd.conf "$@"
