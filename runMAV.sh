#! /bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: runMAV.sh <system_id> <gcs_host1>:<gcs_port1> <gcs_host2>:<gcs_port2> ..."
  exit 1
fi

SYS_ID=$1
SCRIPTS_DIR=$(cd $(dirname $(which $0)); pwd)

DESTINATIONS=""

echo "Number of destinations:" $(( $# - 1 ))
for src in ${@:2}
do
    DESTINATIONS+="--out=udpout:${src} "
done
echo $DESTINATIONS

echo "Running SITL simulation ..."
echo SYS_ID=$SYS_ID GCS_HOST=$2 GCS_PORT=$3
echo SIM_OPTIONS=$SIM_OPTIONS
docker run --rm -it \
  -v $SCRIPTS_DIR:/external \
  -e "SIM_OPTIONS=$DESTINATIONS -m --target-system=$SYS_ID $SIM_OPTIONS" \
  --entrypoint "/external/entryPoint.sh" \
  furkanguvenc/ardupilot-sitl:latest $SYS_ID
exit $?
