. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh

# Generate channel configuration transaction
function generateOrgDefinition() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
  fatalln "configtxgen tool not found. exiting"
  fi
  infoln "Generating ${HOST_NAME_ABRR} organization definition"

  set -x
  configtxgen -printOrg ${CORE_PEER_LOCALMSPID} -configPath newOrgConfigtx > ${FABRIC_CA_CLIENT_HOME}/${HOST_NAME_ABRR}.json
  res=$?
  { set +x; } 2>/dev/null
  if [ $res -ne 0 ]; then
  fatalln "Failed to generate ${HOST_NAME_ABRR} organization definition..."
  fi
}

if [ -e ${PWD}/newOrgConfigtx ]; then
    echo "new org added to existed channel, definition needed."
    generateOrgDefinition
else
    echo "lack newOrgConfigtx which hold configtx"
fi