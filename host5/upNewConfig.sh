set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null

echo "submit and update channel config to channel through node peer of org5"
docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org5; pwd; ./updateConfigtx.sh ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb"