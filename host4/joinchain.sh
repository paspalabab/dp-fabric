set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null

# let peers join the channel
for each_org_config_path in "${orglist[@]}"
do
   docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_org_config_path; pwd; ./joinchan.sh"
done

sleep 3
for each_org_config_path in "${orglist[@]}"
do
    docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/$each_org_config_path; pwd; ./query.sh"
done
