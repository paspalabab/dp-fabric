set -x
HOME_FOR_SETUP=${PWD}
declare -a orglist=("org6")
declare -a existingOrglist=("org1" "org2" "org3" "org4" "org5")
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/scripts/host.sh
{ set +x; } 2>/dev/null

echo "remove peer node of org6"
for each_org_config_path in "${existingOrglist[@]}"
do
   if [ ${each_org_config_path} = "org1" ]; then
       echo "fetch config through node peer of ${each_org_config_path}"
       echo "Creating config transaction to add new org to network through node peer of ${each_org_config_path}"
       docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx; ./removePeer.sh --genupconfig true --upconfigpath ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb --rm-msp Org6MSP --original-config ${FABRIC_CLI_WORK_HOME}/configtx/cur_chan_config.json --modified-config ${FABRIC_CLI_WORK_HOME}/configtx/modified_config.json"
      
   elif [ ${each_org_config_path} = "org5" ]; then
       echo "submit and update channel config through node peer of ${each_org_config_path}"
       docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./updateConfigtx.sh ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb"
   else
       echo "sign the updated channel config by node peer of ${each_org_config_path}"
       docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./removePeer.sh --upconfigpath ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb"
   fi
done


sleep 3
echo "check peer and channel block info though node peer of org6"
docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org6; pwd; ./query.sh; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx"
echo "the error above is reasonable for the peer has leaved the channel and the block fetch previledge has been deprived"

echo "check peer and channel block info though node peer of org1"
docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org1; pwd; ./query.sh; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx"

