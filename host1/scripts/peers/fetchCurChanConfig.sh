. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${PEER_SCRIPTS_PATH}/channel.sh

OUTPUT=$1

fetchChannelConfig $CHANNEL_NAME ${OUTPUT}/cur_chan_config.json