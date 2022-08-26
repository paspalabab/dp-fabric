. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${PEER_SCRIPTS_PATH}/channel.sh

UPDATE_CONFIG=$1

set -x
peer channel update -f ${UPDATE_CONFIG} -c $CHANNEL_NAME  -o ${ORDERER_SERVICE_ADDRESS} --ordererTLSHostnameOverride ${CA_REG_ORDERER_HOST} --tls --cafile "$ORDERER_CA" >&update_log.txt
{ set +x; } 2>/dev/null


