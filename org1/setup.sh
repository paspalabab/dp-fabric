. env.sh
. utils.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

function createOrgs() {
  if [ -d "organizations/peerOrganizations" ]; then
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
  fi

  # Create crypto material using Fabric CA
  infoln "Generating certificates using Fabric CA"
  ${CONTAINER_CLI_COMPOSE} -f $COMPOSE_FILE_CA up -d 2>&1

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

function networkUp() {

  if [ -d "organizations/peerOrganizations" ]; then
    rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
  fi

  # generate artifacts if they don't exist
  # if [ ! -d "organizations/peerOrganizations" ]; then
    createOrgs
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