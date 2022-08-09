ROOTDIR=$(cd "$(dirname "$0")" && pwd)
export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH
# export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# Versions of fabric known not to work with the test network
NONWORKING_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

# docker tools env
: ${CONTAINER_CLI:="docker"}
: ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
# infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"
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

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"
# another container before giving up
MAX_RETRY=5
# default for delay between commands
CLI_DELAY=1

# export ORDERER_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/orderer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
# export CORE_PEER_LOCALMSPID="Org2MSP"
# export CORE_PEER_MSPCONFIGPATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
# export CORE_PEER_ADDRESS=localhost:7051
export FABRIC_CFG_PATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/config


# export CORE_PEER_TLS_ENABLED=true
# export CORE_PEER_PROFILE_ENABLED=false
# export CORE_PEER_TLS_CERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
# export CORE_PEER_TLS_KEY_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
# export CORE_PEER_TLS_ROOTCERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/orderer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_ORG2_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051

BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"