FROM ubuntu:16.04

ENV REGION us-west-2
#override this file with a bind mount
ENV AWS_LOGS_CONF=/awslogs.conf

RUN echo -e '[general]\n\
    state_file = /var/awslogs/state/agent-state\n'\
    >> $AWS_LOGS_CONF

RUN apt-get update && apt-get install --no-install-recommends -q -y python python-pip wget && rm -rf /var/lib/apt/lists/*
RUN wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py && \
    mkdir /etc/cron.d && \
    python /awslogs-agent-setup.py -n -r ${REGION} -c ${AWS_LOGS_CONF}

ADD start.sh /
RUN chmod a+x /start.sh
CMD /start.sh

LABEL org.label-schema.name="ernestoojeda/awslogs" \
    org.label-schema.description="Wrapper for AWS Cloudwatch logs Agent" \
    org.label-schema.schema-version="1.0"