ROOTDIR=$(cd "$(dirname "$0")" && pwd)
export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH
# export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

# Versions of fabric known not to work with the test network
NONWORKING_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

. utils.sh

: ${CONTAINER_CLI:="docker"}
: ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"
SOCK="${DOCKER_HOST:-/var/run/docker.sock}"
DOCKER_SOCK="${SOCK##unix://}"

# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=compose-orderer.yaml
# certificate authorities compose file
COMPOSE_FILE_CA=compose-ca.yaml

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
      if [ ! -f "organizations/fabric-ca/ordererOrg/tls-cert.pem" ]; then
        sleep 1
      else
        break
      fi
    done

  infoln "Creating Orderer Identities"

  createOrderer

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
  COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"

  DOCKER_SOCK="${DOCKER_SOCK}" ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} up -d 2>&1

  $CONTAINER_CLI ps
  if [ $? -ne 0 ]; then
    fatalln "Unable to start network"
  fi
}

networkUp