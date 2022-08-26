export SET_HOST_NAME="fabric-host2"
FABRIC_CLI=fabric-cli-$SET_HOST_NAME
FABRIC_CA_CLI=fabric-ca-cli-$SET_HOST_NAME
declare -a ordererlist=("orderer2")
declare -a orglist=("org2")