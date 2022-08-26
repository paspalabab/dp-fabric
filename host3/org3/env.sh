# common config scripts path
COMMON_SCRIPTS_PATH=${PWD}/../scripts
PEER_SCRIPTS_PATH=${COMMON_SCRIPTS_PATH}/peers

export DOCKER_SOCK_HOST='${DOCKER_SOCK}'
export SET_COUCHDB_HOST=couchdb2
export SET_COUCHDB_USER=admin
export SET_COUCHDB_PASSWORD=adminpw
export SET_COUCHDB_LOCAL_PORT=5984
export SET_COUCHDB_HOST_PORT=5986
export SET_PEER_LISTENPORT=8521
export SET_CHAINCODE_SERPORT=8522
export SET_OPERATIONS_LISTENPORT=8523
export SET_CHAINCODE_CONFIG='{"peername":"peer0org3"}'

# 1.Home path of config files fetched by ca client from ca server
THIS_ORG_HOST=org3.example.com
HOST_NAME_ABRR=Org3
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/${THIS_ORG_HOST}
FABRIC_CA_CERT=${PWD}/../fabric-ca/organizations/fabric-ca/org/ca-cert.pem
FABRIC_CA_NAME=fabric-ca

# 1.1 CA net infor, must in sync with compose-ca.yaml
# CA_SERVICE_PORT=9054
# CA_SERVICE_IP=localhost
# CA_SERVICE_ADDRESS=${CA_SERVICE_IP}:${CA_SERVICE_PORT}
# CA_ADMIN_NAME=admin
# CA_ADMIN_PW=adminpw

# 1.2 host infor of peer node
export CA_REG_PEER_HOST=peer0.${THIS_ORG_HOST}

# 1.3 user info 
CA_REG_PEER_NAME=${HOST_NAME_ABRR}peer0
CA_REG_PEER_PW=${HOST_NAME_ABRR}peer0pw
CA_REG_PEER_ADMIN_NAME=${HOST_NAME_ABRR}admin
CA_REG_PEER_ADMIN_PW=${HOST_NAME_ABRR}adminpw
CA_REG_PEER_USER1_NAME=${HOST_NAME_ABRR}user1
CA_REG_PEER_USER1_PW=${HOST_NAME_ABRR}user1pw

# 1.4 key applicaiton context field
ORG_NUMBER=3
PEER_SERVICE_ADDR=${CA_REG_PEER_HOST}
PEER_SERVICE_PORT=${SET_PEER_LISTENPORT}

# 2. orderer node service visit context when 
ORDERER_CA=${PWD}/../orderer3/organizations/tlsca/tlsca.example.com-cert.pem
CA_REG_ORDERER_HOST=orderer3.example.com
ORDERER_SERVICE_ADDRESS=${CA_REG_ORDERER_HOST}:8052

# 3.default core config of peer node 
export FABRIC_CFG_PATH=${PWD}/config

# 4. runtime context of peer node
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="${HOST_NAME_ABRR}MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.${THIS_ORG_HOST}-cert.pem
export CORE_PEER_MSPCONFIGPATH=${FABRIC_CA_CLIENT_HOME}/users/Admin@${THIS_ORG_HOST}/msp
export CORE_PEER_ADDRESS=${PEER_SERVICE_ADDR}:${PEER_SERVICE_PORT}
