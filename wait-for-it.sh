#!/usr/bin/env bash
#   Use this script to test if a given TCP host/port are available
#   From: https://github.com/vishnubob/wait-for-it

set -e

HOST=$1
PORT=$2
shift 2
TIMEOUT=15

until $(nc -z -v -w $TIMEOUT $HOST $PORT); do
  >&2 echo "Waiting for $HOST:$PORT to be available..."
  sleep 1
done

>&2 echo "$HOST:$PORT is available, continuing..."
exec "$@"
