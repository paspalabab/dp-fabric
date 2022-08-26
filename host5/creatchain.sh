set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null

# create the channel
for each_orderer_config_path in "${ordererlist[@]}"
do
   # cd ${HOME_FOR_SETUP}/${each_orderer_config_path}
   
   if [ ${each_orderer_config_path} = "orderer1" ]
   then
      docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_orderer_config_path; pwd; ./setchan.sh --cfgxpath ${FABRIC_CLI_WORK_HOME}/configtx --genblockpath ${FABRIC_CLI_WORK_HOME}/configtx/channel-artifacts"
   else
      docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_orderer_config_path; pwd; ./setchan.sh --genblockpath ${FABRIC_CLI_WORK_HOME}/configtx/channel-artifacts"
   fi
done