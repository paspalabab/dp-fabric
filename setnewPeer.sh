set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
declare -a orglist=("org6")
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/scripts/host.sh
{ set +x; } 2>/dev/null


echo "prepair the scripts and create the org though ca interacting for Orgs. "
# set up the org peer nodes
for each_org_config_path in "${orglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   cp ../scripts/peers/setup.sh . && cp ../scripts/peers/query.sh . && cp ../scripts/peers/dismantle.sh . \
   && cp ../scripts/peers/joinchan.sh . && cp ../scripts/peers/fetchCurChanConfig.sh . \
   && cp ../scripts/peers/createAndSignNewOrgConfig.sh . && cp ../scripts/peers/updateConfigtx.sh . \
   && cp ../scripts/peers/removePeer.sh . && cp ../scripts/peers/createOrgs.sh . && cp ../scripts/peers/generateOrgDefinition.sh .

   docker exec $FABRIC_CA_CLI /bin/sh -c "cd etc/hyperledger/home/$each_org_config_path; pwd; ./createOrgs.sh"
   docker exec $FABRIC_CLI /bin/sh -c "cd $FABRIC_CLI_WORK_HOME/$each_org_config_path; pwd; ./generateOrgDefinition.sh"
   
   mkdir -p ${FABRIC_CONFIGTX_PATH}/cryptogen/peer${each_org_config_path}
   sudo cp -rf ${HOME_FOR_SETUP}/${each_org_config_path}/organizations/peerOrganizations/${each_org_config_path}.example.com/msp \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/peer${each_org_config_path}
done

docker exec -it $FABRIC_CLI sh -c "chmod -R 777 $FABRIC_CLI_WORK_HOME"

echo "set up Orgs. "
for each_org_config_path in "${orglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   ./setup.sh
done