set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null

echo "set up orders. "
for each_orderer_config_path in "${ordererlist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_orderer_config_path}
   ./setup.sh
done

echo "set up Orgs. "
for each_org_config_path in "${orglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   ./setup.sh
done