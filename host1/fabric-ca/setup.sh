. env.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${COMMON_SCRIPTS_PATH}/NetworkUpAndDown.sh

mkdir -p organizations/fabric-ca/org && cp ../scripts/ca/fabric-ca-server-config.yaml organizations/fabric-ca/org

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

networkUp