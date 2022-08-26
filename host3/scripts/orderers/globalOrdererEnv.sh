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
CA_SERVICE_IP=fabric-ca
CA_SERVICE_ADDRESS=${CA_SERVICE_IP}:${CA_SERVICE_PORT}
CA_ADMIN_NAME=admin
CA_ADMIN_PW=adminpw
