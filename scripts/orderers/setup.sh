. env.sh
. ${ORDERER_SCRIPTS_PATH}/globalOrdererEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${ORDERER_SCRIPTS_PATH}/createOrgs.sh
. ${COMMON_SCRIPTS_PATH}/NetworkUpAndDown.sh
. ${ORDERER_SCRIPTS_PATH}/genOrdererCompose.sh

mkdir -p organizations

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

createOrgs
networkUp