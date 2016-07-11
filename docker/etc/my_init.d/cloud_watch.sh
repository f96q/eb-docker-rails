#!/bin/sh

if [ -n "$ALARM_NAME" ]; then
  aws_instance_id="$(curl http://169.254.169.254/latest/meta-data/instance-id)"

  aws cloudwatch put-metric-alarm \
    --region ap-northeast-1 \
    --alarm-name "${ALARM_NAME}-cpu-${aws_instance_id}" \
    --namespace "AWS/EC2" \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value=${aws_instance_id} \
    --statistic Average \
    --threshold 80 \
    --unit Percent \
    --period 300 \
    --evaluation-periods 1 \
    --comparison-operator GreaterThanThreshold \
    --ok-actions $ARN_ACTION \
    --alarm-actions $ARN_ACTION \
    --insufficient-data-actions $ARN_ACTION

  aws cloudwatch put-metric-alarm \
    --region ap-northeast-1 \
    --alarm-name "${ALARM_NAME}-memory-${aws_instance_id}" \
    --namespace "System/Linux" \
    --metric-name MemoryUtilization \
    --dimensions Name=InstanceId,Value=${aws_instance_id} \
    --statistic Maximum \
    --threshold 80 \
    --unit Percent \
    --period 300 \
    --evaluation-periods 1 \
    --comparison-operator GreaterThanThreshold \
    --ok-actions $ARN_ACTION \
    --alarm-actions $ARN_ACTION \
    --insufficient-data-actions $ARN_ACTION

  aws cloudwatch put-metric-alarm \
    --region ap-northeast-1 \
    --alarm-name "${ALARM_NAME}-disk-${aws_instance_id}" \
    --namespace "System/Linux" \
    --metric-name DiskSpaceUtilization \
    --dimensions Name=InstanceId,Value=${aws_instance_id} Name=Filesystem,Value="/dev/xvda1" Name=MountPath,Value=/ \
    --statistic Maximum \
    --threshold 80 \
    --unit Percent \
    --period 300 \
    --evaluation-periods 1 \
    --comparison-operator GreaterThanThreshold \
    --ok-actions $ARN_ACTION \
    --alarm-actions $ARN_ACTION \
    --insufficient-data-actions $ARN_ACTION
fi
