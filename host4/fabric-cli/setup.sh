. env.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${COMMON_SCRIPTS_PATH}/host.sh
. ${COMMON_SCRIPTS_PATH}/NetworkUpAndDown.sh
. ${CLI_SCRIPTS_PATH}/genCliCompose.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

networkUp