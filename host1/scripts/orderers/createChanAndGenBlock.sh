createChannelGenesisBlock() {
	which configtxgen
	if [ "$?" -ne 0 ]; then
		fatalln "configtxgen tool not found."
	fi
	set -x
	configtxgen -configPath ${CC_CFGX_PATH} -profile ApplicationGenesis -outputBlock ${CC_GENESIS_BLOCK_PATH}/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
    verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
	# Poll in case the raft leader is not set yet
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $CLI_DELAY
		set -x
		# osnadmin channel list --channelID $CHANNEL_NAME -o ${ORDERER_ADMIN_ADDRESS} --ca-file "$FABRIC_CA_CERT" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" 
		osnadmin channel join --channelID $CHANNEL_NAME --config-block ${CC_GENESIS_BLOCK_PATH}/${CHANNEL_NAME}.block -o ${ORDERER_ADMIN_ADDRESS} --ca-file "$FABRIC_CA_CERT" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >&log_setchan.txt
    	osnadmin channel list --channelID $CHANNEL_NAME -o ${ORDERER_ADMIN_ADDRESS} --ca-file "$FABRIC_CA_CERT" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >&log_query.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log_setchan.txt
	verifyResult $res "Channel creation failed"
}