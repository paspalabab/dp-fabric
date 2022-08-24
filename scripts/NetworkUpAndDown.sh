ROOTDIR=$(cd "$(dirname "$0")" && pwd)
export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH

export VERBOSE=false

: ${CONTAINER_CLI:="docker"}
: ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
# infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"
SOCK="${DOCKER_HOST:-/var/run/docker.sock}"
DOCKER_SOCK="${SOCK##unix://}"

export FabricUID=$(id -u)
export GID=$(id -g)

# Versions of fabric known not to work with the test network
NONWORKING_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

function networkUp() {
  set -x
  DOCKER_SOCK="${DOCKER_SOCK}" ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} up -d 2>&1
  { set +x; } 2>/dev/null

  $CONTAINER_CLI ps
  if [ $? -ne 0 ]; then
    fatalln "Unable to start network"
  fi
}

# Tear down running network
function networkDown() {
  set -x
  sudo rm -Rf ${FILES_LIST_FOR_NETDOWN_CLEAR}
  { set +x; } 2>/dev/null

  if [ "${CONTAINER_CLI}" == "docker" ]; then
    set -x
    DOCKER_SOCK=$DOCKER_SOCK ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} down --volumes --remove-orphans
    { set +x; } 2>/dev/null
  else
    fatalln "Container CLI  ${CONTAINER_CLI} not supported"
  fi
}