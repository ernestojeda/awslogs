# awslogs

## Description
A docker image that wraps the AWS Cloudwatch logs python binary. Use it to send another container's log files to CloudWatch.

## Usage:

Create a config file that the cloudwatch logs agent will use.

cat /opt/awslogs.conf

	[general]
	state_file = /var/awslogs/state/agent-state
	
	[/var/log/nginx/access.log]
	file = /var/log/nginx/access.log
	log_group_name = ec2-instance-syslogs
	log_stream_name = {instance_id}
	datetime_format = %Y-%m-%dT%H:%M:%S.%f

Run Command Example

	docker run --name web -d -v weblogs:/var/log/nginx nginx
	docker run --name web_cloudwatch_logs \
	   -v /opt/awslogs.conf:/awslogs.conf \
	   -v weblogs/access.log:/var/log/nginx/access.log