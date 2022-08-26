. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${PEER_SCRIPTS_PATH}/channel.sh

# Join all the peers to the channel
infoln "Joining peer of ${HOST_NAME_ABRR} to the channel..."
joinChannel ${CA_REG_PEER_HOST}

createAnchorPeerUpdate
updateAnchorPeer
# peerChannelQuery