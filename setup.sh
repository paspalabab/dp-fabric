set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
declare -a ordererlist=("orderer1" "orderer2" "orderer3" "orderer4" "orderer5" )
declare -a orglist=("org1" "org2" "org3" "org4" "org5")
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
   
   docker exec fabric-ca-cli /bin/sh -c "cd etc/hyperledger/home/$each_orderer_config_path; pwd; ./createOrgs.sh"

   mkdir -p ${FABRIC_CONFIGTX_PATH}/cryptogen/${each_orderer_config_path}
   sudo cp ${HOME_FOR_SETUP}/${each_orderer_config_path}/${ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH} \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/${each_orderer_config_path}
   sudo cp -rf ${HOME_FOR_SETUP}/${each_orderer_config_path}/${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/msp \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/${each_orderer_config_path}
done

echo "set up orders. "
for each_orderer_config_path in "${ordererlist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_orderer_config_path}
   ./setup.sh
done

echo "prepair the scripts and create the org though ca interacting for Orgs. "
# set up the org peer nodes
for each_org_config_path in "${orglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   cp ../scripts/peers/setup.sh . && cp ../scripts/peers/query.sh . && cp ../scripts/peers/dismantle.sh . \
   && cp ../scripts/peers/joinchan.sh . && cp ../scripts/peers/fetchCurChanConfig.sh . \
   && cp ../scripts/peers/createAndSignNewOrgConfig.sh . && cp ../scripts/peers/updateConfigtx.sh . \
   && cp ../scripts/peers/removePeer.sh . && cp ../scripts/peers/createOrgs.sh . && cp ../scripts/peers/generateOrgDefinition.sh .

   docker exec fabric-ca-cli /bin/sh -c "cd etc/hyperledger/home/$each_org_config_path; pwd; ./createOrgs.sh"
   
   mkdir -p ${FABRIC_CONFIGTX_PATH}/cryptogen/peer${each_org_config_path}
   sudo cp -rf ${HOME_FOR_SETUP}/${each_org_config_path}/organizations/peerOrganizations/${each_org_config_path}.example.com/msp \
   ${FABRIC_CONFIGTX_PATH}/cryptogen/peer${each_org_config_path}
done

echo "set up Orgs. "
for each_org_config_path in "${orglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   ./setup.sh
done

# create the channel
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
for each_orderer_config_path in "${ordererlist[@]}"
do
   # cd ${HOME_FOR_SETUP}/${each_orderer_config_path}
   
   if [ ${each_orderer_config_path} = "orderer1" ]
   then
      docker exec fabric-cli /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_orderer_config_path; pwd; ./setchan.sh --cfgxpath ${FABRIC_CLI_WORK_HOME}/configtx --genblockpath ${FABRIC_CLI_WORK_HOME}/configtx/channel-artifacts"
   else
      docker exec fabric-cli /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_orderer_config_path; pwd; ./setchan.sh --genblockpath ${FABRIC_CLI_WORK_HOME}/configtx/channel-artifacts"
   fi
done
sleep 3

# let peers join the channel
for each_org_config_path in "${orglist[@]}"
do
   docker exec fabric-cli /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_org_config_path; pwd; ./joinchan.sh"
done

sleep 3
for each_org_config_path in "${orglist[@]}"
do
    docker exec fabric-cli /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_org_config_path; pwd; ./query.sh"
done
