#!/bin/bash
pods=$(kubectl get pod -n $1 -o json)
nodes=5
for ((n = 2; n <= $nodes; n++));
do
    node="pi-cluster-0$n"
    json=$(echo $pods | jq "
        [
            .items[]
            | select (.kind==\"Pod\" and .spec.nodeName==\"$node\") 
            | { name: .metadata.name, node: .spec.nodeName, status: .status.phase | ascii_downcase} ] 
        | group_by(.node) 
        | map({
            \"node\": .[0].node, 
            \"count\": length, 
            \"statuses\": (group_by(.status) | map({
                \"key\": .[0].status, 
                \"value\": length 
            }) | from_entries)
        })
        | .[0]")

    running=`echo $json | jq ".statuses | .running // 0"`
    pending=`echo $json | jq ".statuses | .pending // 0"`
    left=`expr 16 - $running - $pending`
    left=$(($left<0?0:$left))

    for ((i = 0; i < $running; i++));
    do
        args=$args'1'
    done
    
    for ((i = 0; i < $pending; i++));
    do
        args=$args'2'
    done
    
    for ((i = 0; i < $left; i++));
    do
        args=$args'0'
    done
done

echo $args