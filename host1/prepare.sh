set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null

mkdir -p configtx/cryptogen
cp scripts/configtx.yaml configtx

# set up ca agency 
cd $HOME_FOR_SETUP/fabric-cli/
./setup.sh
cd $HOME_FOR_SETUP/fabric-ca-cli/
./setup.sh
cd $HOME_FOR_SETUP/fabric-ca/
./setup.sh
echo "wait for 3 seconds before the ca server is ready..."
sleep 3

# set up orderer nodes

echo "prepair the scripts and create the org though ca interacting for orderers. "
for each_orderer_config_path in "${ordererlist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_orderer_config_path}
   cp ../scripts/orderers/setup.sh .  && cp ../scripts/orderers/dismantle.sh . && cp ../scripts/orderers/setchan.sh . && cp ../scripts/orderers/createOrgs.sh . \
   
   docker exec $FABRIC_CA_CLI /bin/sh -c "cd etc/hyperledger/home/$each_orderer_config_path; pwd; ./createOrgs.sh"

   mkdir -p ${FABRIC_CONFIGTX_PATH}/cryptogen/${each_orderer_config_path}
   sudo cp ${HOME_FOR_SETUP}/${each_orderer_config_path}/${ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH} \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/${each_orderer_config_path}
   sudo cp -rf ${HOME_FOR_SETUP}/${each_orderer_config_path}/${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/msp \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/${each_orderer_config_path}
done

echo "prepair the scripts and create the org though ca interacting for Orgs. "

# set up the org peer nodes
for each_org_config_path in "${orglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   cp ../scripts/peers/setup.sh . && cp ../scripts/peers/query.sh . && cp ../scripts/peers/dismantle.sh . \
   && cp ../scripts/peers/joinchan.sh . && cp ../scripts/peers/fetchCurChanConfig.sh . \
   && cp ../scripts/peers/createAndSignNewOrgConfig.sh . && cp ../scripts/peers/updateConfigtx.sh . \
   && cp ../scripts/peers/removePeer.sh . && cp ../scripts/peers/createOrgs.sh . && cp ../scripts/peers/generateOrgDefinition.sh . \
   && cp ../scripts/peers/deployCC.sh .

   docker exec $FABRIC_CA_CLI /bin/sh -c "cd etc/hyperledger/home/$each_org_config_path; pwd; ./createOrgs.sh"
   
   mkdir -p ${FABRIC_CONFIGTX_PATH}/cryptogen/peer${each_org_config_path}
   sudo cp -rf ${HOME_FOR_SETUP}/${each_org_config_path}/organizations/peerOrganizations/${each_org_config_path}.example.com/msp \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/peer${each_org_config_path}
done

docker exec -it $FABRIC_CLI sh -c "chmod -R 777 $FABRIC_CLI_WORK_HOME"