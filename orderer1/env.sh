# common config scripts path
COMMON_SCRIPTS_PATH=${PWD}/../scripts
ORDERER_SCRIPTS_PATH=${COMMON_SCRIPTS_PATH}/orderers

# CA service, must in sync with compose-ca.yaml
CA_SERVICE_PORT=9054
CA_SERVICE_IP=localhost
CA_SERVICE_ADDRESS=${CA_SERVICE_IP}:${CA_SERVICE_PORT}
CA_ADMIN_NAME=admin
CA_ADMIN_PW=adminpw

export CA_REG_ORDERER_HOST=orderer.example.com
CA_REG_ORDERER_NAME=orderer
CA_REG_ORDERER_PW=ordererpw
CA_REG_ORDERER_ADMIN_NAME=ordererAdmin
CA_REG_ORDERER_ADMIN_PW=ordererAdminpw

# orderer service parameters
export SET_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
export SET_GENERAL_LOCALTLSDIR=/var/hyperledger/orderer/tls
export SET_GENERAL_LISTENPORT=8050
export SET_ADMIN_LISTENADDRESS_PORT=8150
export SET_OPERATIONS_LISTENADDRESS_PORT=8250
ORDERER_ADMIN_ADDRESS=localhost:${SET_ADMIN_LISTENADDRESS_PORT}