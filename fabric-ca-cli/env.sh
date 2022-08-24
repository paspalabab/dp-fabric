ROOTDIR=$(cd "$(dirname "$0")" && pwd)
export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH
# export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# common config scripts path
COMMON_SCRIPTS_PATH=${PWD}/../scripts
ORDERER_SCRIPTS_PATH=${COMMON_SCRIPTS_PATH}/orderer

: ${CONTAINER_CLI:="docker"}
: ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
# infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"
SOCK="${DOCKER_HOST:-/var/run/docker.sock}"
DOCKER_SOCK="${SOCK##unix://}"

export FabricUID=$(id -u)
export GID=$(id -g)

# Versions of fabric known not to work with the test network
NONWORKING_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

# certificate authorities compose file
COMPOSE_FILE_BASE=compose-ca-cli.yaml
COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"
# common config scripts path
COMMON_SCRIPTS_PATH=${PWD}/../scripts

FILES_LIST_FOR_NETDOWN_CLEAR='./organizations/fabric-ca'

