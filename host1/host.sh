export SET_HOST_NAME="fabric-host1"
FABRIC_CLI=fabric-cli-$SET_HOST_NAME
FABRIC_CA_CLI=fabric-ca-cli-$SET_HOST_NAME
declare -a ordererlist=("orderer1")
declare -a orglist=("org1")