# common config scripts path
COMMON_SCRIPTS_PATH=${PWD}/../scripts
ORDERER_SCRIPTS_PATH=${COMMON_SCRIPTS_PATH}/orderers

# CA service, must in sync with compose-ca.yaml
CA_REG_ORDERER_HOST=orderer4.example.com
CA_REG_ORDERER_NAME=orderer4
CA_REG_ORDERER_PW=ordererpw
CA_REG_ORDERER_ADMIN_NAME=orderer4Admin
CA_REG_ORDERER_ADMIN_PW=ordererAdminpw

# orderer service parameters
export SET_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
export SET_GENERAL_LOCALTLSDIR=/var/hyperledger/orderer/tls
export SET_GENERAL_LISTENPORT=8053
export SET_ADMIN_LISTENADDRESS_PORT=8153
export SET_OPERATIONS_LISTENADDRESS_PORT=8253
ORDERER_ADMIN_ADDRESS=${CA_REG_ORDERER_HOST}:${SET_ADMIN_LISTENADDRESS_PORT}