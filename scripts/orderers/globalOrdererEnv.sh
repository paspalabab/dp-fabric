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

FILES_LIST_FOR_NETDOWN_CLEAR='channel-artifacts organizations *.json *.pb *.txt'

# provided by fabric ca, it is neccesary to copy the ca certificate to this path in advance
FABRIC_CA_CERT=${PWD}/../fabric-ca/organizations/fabric-ca/org/ca-cert.pem
FABRIC_CA_NAME=fabric-ca

# use this as the default docker-compose yaml definition
COMPOSE_FILE_BASE=compose-orderer.yaml
COMPOSE_FILES="-f ${COMPOSE_FILE_BASE}"

# environment varibles for config ops
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations
export ORDERER_ADMIN_TLS_SIGN_CERT=${FABRIC_CA_CLIENT_HOME}/orderers/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${FABRIC_CA_CLIENT_HOME}/orderers/tls/server.key

# CA service, must in sync with compose-ca.yaml
CA_SERVICE_PORT=9054
CA_SERVICE_IP=192.168.0.193
CA_SERVICE_ADDRESS=${CA_SERVICE_IP}:${CA_SERVICE_PORT}
CA_ADMIN_NAME=admin
CA_ADMIN_PW=adminpw
