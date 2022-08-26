set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null


echo "sign the updated channel config by node peer of org3"
docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org3; pwd; ./createAndSignNewOrgConfig.sh --upconfigpath ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb"

