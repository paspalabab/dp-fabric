set -x
HOME_FOR_SETUP=${PWD}
declare -a orglist=("org6")
declare -a existingOrglist=("org1" "org2" "org3" "org4" "org5")
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/scripts/host.sh
{ set +x; } 2>/dev/null

for each_org_config_path in "${existingOrglist[@]}"
do
   if [ ${each_org_config_path} = "org1" ]; then
       echo "fetch config through node peer of ${each_org_config_path}"
       echo "Creating config transaction to add new org to network through node peer of ${each_org_config_path}"
       docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx; ./createAndSignNewOrgConfig.sh --genupconfig true --upconfigpath ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb --newmsp Org6MSP --newdef ${FABRIC_CLI_WORK_HOME}/org6/organizations/peerOrganizations/org6.example.com/Org6.json --original-config ${FABRIC_CLI_WORK_HOME}/configtx/cur_chan_config.json --modified-config ${FABRIC_CLI_WORK_HOME}/configtx/modified_config.json"
   elif [ ${each_org_config_path} = "org5" ]; then
       echo "submit and update channel config through node peer of ${each_org_config_path}"
       docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./updateConfigtx.sh ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb"
   else
       echo "sign the updated channel config by node peer of ${each_org_config_path}"
       docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./createAndSignNewOrgConfig.sh --upconfigpath ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb"
   fi
done


sleep 3
for each_org_config_path in "${orglist[@]}"
do
   echo "check peer and channel block info though node peer of  ${each_org_config_path}"
   docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./query.sh; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx"
done