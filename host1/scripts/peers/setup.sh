. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${COMMON_SCRIPTS_PATH}/NetworkUpAndDown.sh

mkdir -p config && cp ${PEER_SCRIPTS_PATH}/core.yaml config

. ${PEER_SCRIPTS_PATH}/ccp-generate.sh
. ${PEER_SCRIPTS_PATH}/genCompose.sh

networkUp