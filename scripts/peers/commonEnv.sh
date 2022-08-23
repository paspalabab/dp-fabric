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

# timeout duration - the duration the CLI should wait for a response from
# another container before giving up
MAX_RETRY=5
# default for delay between commands
CLI_DELAY=3
# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

FILES_LIST_FOR_NETDOWN_CLEAR='*config*.json *.pb *.txt log* organizations '

# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=compose-peer.yaml
# use this as the docker env compose yaml definition
COMPOSE_FILE_DOCKER_ENV=docker-compose-peer.yaml
# docker-compose.yaml file if you are using couchdb
COMPOSE_FILE_COUCH=compose-couch.yaml

COMPOSE_FILES="-f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_DOCKER_ENV} -f ${COMPOSE_FILE_COUCH}"

BLOCKFILE=${PWD}/../configtx/channel-artifacts/${CHANNEL_NAME}.block
