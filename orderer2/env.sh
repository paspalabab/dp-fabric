# common config scripts path
COMMON_SCRIPTS_PATH=${PWD}/../scripts
ORDERER_SCRIPTS_PATH=${COMMON_SCRIPTS_PATH}/orderers

# CA service, must in sync with compose-ca.yaml
CA_REG_ORDERER_HOST=orderer2.example.com
CA_REG_ORDERER_NAME=orderer2
CA_REG_ORDERER_PW=ordererpw
CA_REG_ORDERER_ADMIN_NAME=orderer2Admin
CA_REG_ORDERER_ADMIN_PW=ordererAdminpw

# orderer service parameters
export SET_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
export SET_GENERAL_LOCALTLSDIR=/var/hyperledger/orderer/tls
export SET_GENERAL_LISTENPORT=8051
export SET_ADMIN_LISTENADDRESS_PORT=8151
export SET_OPERATIONS_LISTENADDRESS_PORT=8251
ORDERER_ADMIN_ADDRESS=localhost:${SET_ADMIN_LISTENADDRESS_PORT}