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
COMPOSE_FILE_BASE=compose-peer.yaml
# use this as the docker env compose yaml definition
COMPOSE_FILE_DOCKER_ENV=docker-compose-peer.yaml
# docker-compose.yaml file if you are using couchdb
COMPOSE_FILE_COUCH=compose-couch.yaml
# certificate authorities compose file
COMPOSE_FILE_CA=compose-ca.yaml


# Tear down running network
function networkDown() {

  rm -Rf ./channel-artifacts
  rm -Rf ./*config*.json ./*.pb ./*.tx ./log*
  rm -Rf ./organizations/peerOrganizations
  sudo rm -Rf ./organizations/fabric-ca

  COMPOSE_FILES="-f $COMPOSE_FILE_CA -f ${COMPOSE_FILE_COUCH} -f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_DOCKER_ENV} "

  if [ "${CONTAINER_CLI}" == "docker" ]; then
    DOCKER_SOCK=$DOCKER_SOCK ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} down --volumes --remove-orphans
  else
    fatalln "Container CLI  ${CONTAINER_CLI} not supported"
  fi

}

networkDown