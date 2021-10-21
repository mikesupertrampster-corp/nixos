assume() {
  arn=$1
  aws_sts=$(aws sts assume-role --role-arn $arn --role-session-name "$(whoami)")
  export AWS_ACCESS_KEY_ID=$(echo $aws_sts | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo $aws_sts | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo $aws_sts | jq -r '.Credentials.SessionToken')
}

awshosts() {
  ENV=$1
  NAME=$2
  aws ec2 describe-instances --profile $ENV --output table \
    --filters "Name=tag:Name,Values=$NAME" "Name=instance-state-name,Values=[running,pending,shutting-down,stopping]" \
    --query "Reservations[].Instances[].{AZ:Placement.AvailabilityZone,ID:InstanceId,Type:Tags[?Key=='Name']|[0].Value,IP:PrivateIpAddress,InstanceType:InstanceType,Launched:LaunchTime,State:State.Name} | sort_by(@, &Type)"
}

clearssh() {
  unset SSH_AUTH_SOCK
  eval $(ssh-agent)
}

branch() {
  git stash
  git checkout master
  git pull
  git checkout -b $1
  git stash pop
}

mon() {
  autorandr -l default --force --default
  ~/.config/polybar/launch.sh
}
