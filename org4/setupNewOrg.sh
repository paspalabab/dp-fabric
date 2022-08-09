. env.sh
. utils.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT


function createCA() {
  if [ -d "organizations/peerOrganizations" ]; then
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
  fi

  # Create crypto material using Fabric CA
  infoln "Generating certificates using Fabric CA"
  ${CONTAINER_CLI_COMPOSE} -f $COMPOSE_FILE_CA up -d 2>&1
}

function createOrgs() {
  . registerEnroll.sh

  while :
    do
      if [ ! -f "organizations/fabric-ca/org/tls-cert.pem" ]; then
        sleep 1
      else
        break
      fi
    done

  infoln "Creating Org Identities"

  createOrg

  infoln "Generating CCP files for Org"
  ./ccp-generate.sh
}

# Generate channel configuration transaction
function generateOrg4Definition() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
    fatalln "configtxgen tool not found. exiting"
  fi
  infoln "Generating Org4 organization definition"
  export FABRIC_CFG_PATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/configtx
 
  set -x
  configtxgen -printOrg Org4MSP > ./organizations/peerOrganizations/org4.example.com/org4.json
  res=$?
  { set +x; } 2>/dev/null
  if [ $res -ne 0 ]; then
    fatalln "Failed to generate Org4 organization definition..."
  fi
}

function networkUp() {

  if [ -d "organizations/peerOrganizations" ]; then
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
  fi

  # generate artifacts if they don't exist
  # if [ ! -d "organizations/peerOrganizations" ]; then
    createCA
    createOrgs
    generateOrg4Definition
  # fi

  set -x
  COMPOSE_FILES="-f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_DOCKER_ENV} -f ${COMPOSE_FILE_COUCH}"

  DOCKER_SOCK="${DOCKER_SOCK}" ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} up -d 2>&1

  $CONTAINER_CLI ps
  if [ $? -ne 0 ]; then
    fatalln "Unable to start network"
  fi
}

networkUp