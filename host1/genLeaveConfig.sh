set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null


echo "fetch config through node peer of org1"
echo "Creating config transaction to add new org to network through node peer of org1"
docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org1; pwd; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx; ./removePeer.sh --genupconfig true --upconfigpath ${FABRIC_CLI_WORK_HOME}/configtx/update_in_envelope.pb --rm-msp Org6MSP --original-config ${FABRIC_CLI_WORK_HOME}/configtx/cur_chan_config.json --modified-config ${FABRIC_CLI_WORK_HOME}/configtx/modified_config.json"
      