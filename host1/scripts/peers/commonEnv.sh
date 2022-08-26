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

# CA service, must in sync with compose-ca.yaml
CA_SERVICE_PORT=9054
CA_SERVICE_IP=fabric-ca
CA_SERVICE_ADDRESS=${CA_SERVICE_IP}:${CA_SERVICE_PORT}
CA_ADMIN_NAME=admin
CA_ADMIN_PW=adminpw
