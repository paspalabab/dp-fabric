. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${COMMON_SCRIPTS_PATH}/NetworkUpAndDown.sh

mkdir -p organizations
mkdir -p config && cp ${PEER_SCRIPTS_PATH}/core.yaml config

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

. ${PEER_SCRIPTS_PATH}/createOrgs.sh
. ${PEER_SCRIPTS_PATH}/ccp-generate.sh
. ${PEER_SCRIPTS_PATH}/genCompose.sh

networkUp