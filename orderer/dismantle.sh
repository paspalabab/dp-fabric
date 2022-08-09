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


# Tear down running network
function networkDown() {

  rm -Rf ./channel-artifacts
  rm -Rf ./organizations/ordererOrganizations
  rm -Rf ./*config*.json ./*.pb ./*.tx ./log*
  sudo rm -Rf ./organizations/fabric-ca

  set -x
  COMPOSE_FILES="-f $COMPOSE_FILE_CA -f ${COMPOSE_FILE_BASE}"

  if [ "${CONTAINER_CLI}" == "docker" ]; then
    DOCKER_SOCK=$DOCKER_SOCK ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} down --volumes --remove-orphans
  else
    fatalln "Container CLI  ${CONTAINER_CLI} not supported"
  fi


}

networkDown