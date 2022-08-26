export SET_HOST_NAME="fabric-host6"
FABRIC_CLI=fabric-cli-$SET_HOST_NAME
FABRIC_CA_CLI=fabric-ca-cli-$SET_HOST_NAME
declare -a ordererlist=()
declare -a orglist=("org6")