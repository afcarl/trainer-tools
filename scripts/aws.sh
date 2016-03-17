#!/bin/bash

source scripts/cli.sh

aws_display_tags(){
    # Print all "Name" tags in our region with their instance count
    echo "[#] [Status] [Tag]" | awk '{ printf " %7s %8s %10s \n", $1, $2, $3}'
    aws ec2 describe-instances --filter "Name=tag:Name,Values=[*]" \
            --query "Reservations[*].Instances[*].[{Tags:Tags[0].Value,State:State.Name}]" \
        | awk '{ printf " %-13s %-10s %-1s\n", $1, $2, $3}' \
        | uniq -c 
}

aws_display_tokens(){
    # Print all tokens in our region with their instance count
    echo "[#] [Token] [Tag]" | awk '{ printf " %7s %12s %30s\n", $1, $2, $3}'
                            # --query 'Volumes[*].{ID:VolumeId,AZ:AvailabilityZone,Size:Size}'
    aws ec2 describe-instances --output text \
            --query 'Reservations[*].Instances[*].{ClientToken:ClientToken,Tags:Tags[0].Value}' \
        | awk '{ printf " %7s %12s %50s\n", $1, $2, $3}' \
        | sort \
        | uniq -c
}

aws_get_tags() {
    # NOT USED
    #tags=$(aws ec2 describe-tags \
    #    --filters "Name=key,Values=Name" \
    #    --query 'Tags[*].Value[]' \
    #    --output json)
    aws ec2 describe-instances \
        --query 'Reservations[].Instances[].Tags[?Key==`Name`].Value[]'
}

aws_get_tokens() {
    aws ec2 describe-instances --output text \
            --query 'Reservations[*].Instances[*].[ClientToken]' \
        | sort -u
}

aws_display_instances_by_tag() {
    TAG=$1
    need_tag $TAG
    result=$(aws ec2 describe-instances --output table \
                    --filter "Name=tag:Name,Values=$TAG" \
                    --query "Reservations[*].Instances[*].[ \
                        InstanceId, \
                        State.Name, \
                        Tags[0].Value, \
                        PublicIpAddress, \
                        InstanceType \
                        ]"
            )
        if [[ -z $result ]]; then
            echo "No instances found with tag $TAG in region $AWS_DEFAULT_REGION."
        else
            echo "                      ====  $TAG  ===="
            echo "ID State Tags IP Type" \
                | awk '{ printf "%9s %12s %15s %20s %14s \n", $1, $2, $3, $4, $5}' # column -t -c 70}
            echo "$result"
        fi
        # With column headers (but can't specify column order):
        #aws ec2 describe-instances --output text \
        #    --filter "Name=tag:Name,Values=2016-03-03-18-48-aj" \
        #    --query "Reservations[*].Instances[*].{PublicIpAddress:PublicIpAddress,State:State}" 

}

aws_get_instance_ids_by_client_token() {
    TOKEN=$1
    need_tag $TOKEN
    aws ec2 describe-instances --filters "Name=client-token,Values=$TOKEN" \
        | grep ^INSTANCES \
        | awk '{print $8}'
}

aws_get_instance_ids_by_tag() {
    TAG=$1
    need_tag $TAG
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$TAG" \
        | grep ^INSTANCE \
        | awk '{print $8}'
}

aws_get_instance_ips_by_tag() {
    TAG=$1
    need_tag $TAG
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$TAG" \
        --output text \
        --query "Reservations[*].Instances[*].PublicIpAddress" \
            | tr "\t" "\n" \
            | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4  # sort IPs
    # JP: try [PublicIpAddress] to simplify a tiny bit
        #--query [PublicIpAddress] \
        # AJ: ? That doesn't work for me
}

aws_kill_instances_by_tag() {
    TAG=$1
    need_tag $TAG
    IDS=$(aws_get_instance_ids_by_tag $TAG)
    if [ -z "$IDS" ]; then
        die "Invalid tag."
    else
        echo "Deleting instances with tag $TAG"
    fi

    echo "$IDS" \
        | xargs -r aws ec2 terminate-instances --instance-ids \
        | grep ^TERMINATINGINSTANCES
}

