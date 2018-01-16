#!/bin/sh

shutdown_awslogs()
{
    echo "Stopping container..."
    kill $(pgrep -f /var/awslogs/bin/aws)
    exit 0
}

if [ ! -e $AWS_LOGS_CONF ]; then
  echo "Missing AWS log file. Exiting."
  exit 1
fi

trap shutdown_awslogs INT TERM HUP

cp -f $AWS_LOGS_CONF /var/awslogs/etc/awslogs.conf

cat > /var/awslogs/etc/aws.conf <<EOF
[plugins]
cwlogs = cwlogs
[default]
region = ${REGION}
EOF

echo "============================================"
echo "Launching AWS Logs ..."
echo "============================================"
/var/awslogs/bin/awslogs-agent-launcher.sh &

wait
