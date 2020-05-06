#!/bin/bash
PWD=$2
TARGET=$1
curl -X POST -k -u ${PWD} $TARGET/mgmt/shared/cloud-failover/declare -H content-type:application/json -d @./cfe.json
curl -X POST -k -u ${PWD} $TARGET/mgmt/shared/cloud-failover/trigger -H content-type:application/json -d {}
