. env.sh
. utils.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

# joinChannel ORG
joinChannel() {
  
  ORG=$1
	local rc=1
	local COUNTER=1
	## Sometimes Join takes time, hence retry
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $CLI_DELAY
    set -x
    peer channel join -b $BLOCKFILE >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	# verifyResult $res "After $MAX_RETRY attempts, peer0.org${ORG} has failed to join channel '$CHANNEL_NAME' "
}


# fetchChannelConfig <org> <channel_id> <output_json>
# Writes the current channel config for a given channel to a JSON file
# NOTE: this must be run in a CLI container since it requires configtxlator
fetchChannelConfig() {
  CHANNEL=$1
  OUTPUT=$2

  infoln "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL --tls --cafile "$ORDERER_CA"
  { set +x; } 2>/dev/null

  infoln "Decoding config block to JSON and isolating config to ${OUTPUT}"
  set -x
  configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
  jq .data.data[0].payload.data.config config_block.json >"${OUTPUT}"
  { set +x; } 2>/dev/null
}

createConfigUpdate() {
  CHANNEL=$1
  ORIGINAL=$2
  MODIFIED=$3
  OUTPUT=$4

  set -x
  configtxlator proto_encode --input "${ORIGINAL}" --type common.Config --output original_config.pb
  configtxlator proto_encode --input "${MODIFIED}" --type common.Config --output modified_config.pb
  configtxlator compute_update --channel_id "${CHANNEL}" --original original_config.pb --updated modified_config.pb --output config_update.pb
  configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json
  echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL'", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
  configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output "${OUTPUT}"
  { set +x; } 2>/dev/null
}

createAnchorPeerUpdate() {
  infoln "Fetching channel config for channel $CHANNEL_NAME"
  fetchChannelConfig $CHANNEL_NAME ${CORE_PEER_LOCALMSPID}config.json

  infoln "Generating anchor peer update transaction for Org${ORG} on channel $CHANNEL_NAME"

  HOST="peer0.org4.example.com"
  PORT=12051

  set -x
  # Modify the configuration to append the anchor peer 
  jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json
  { set +x; } 2>/dev/null

  # Compute a config update, based on the differences between 
  # {orgmsp}config.json and {orgmsp}modified_config.json, write
  # it as a transaction to {orgmsp}anchors.tx
  createConfigUpdate ${CHANNEL_NAME} ${CORE_PEER_LOCALMSPID}config.json ${CORE_PEER_LOCALMSPID}modified_config.json ${CORE_PEER_LOCALMSPID}anchors.tx
}

updateAnchorPeer() {
  set -x
  peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ${CORE_PEER_LOCALMSPID}anchors.tx --tls --cafile "$ORDERER_CA" >&log.txt
  { set +x; } 2>/dev/null
  res=$?
  cat log.txt
  verifyResult $res "Anchor peer update failed"
  successln "Anchor peer set for org '$CORE_PEER_LOCALMSPID' on channel '$CHANNEL_NAME'"
}

signConfigtxAsPeerOrg() {
  CONFIGTXFILE=$1
  set -x
  peer channel signconfigtx -f "${CONFIGTXFILE}"
  { set +x; } 2>/dev/null
}



export ORDERER_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/orderer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org1/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
export CORE_PEER_LOCALMSPID="Org1MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_org1_CA
export CORE_PEER_MSPCONFIGPATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org1/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
export FABRIC_CFG_PATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org1/config


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=false
export CORE_PEER_TLS_CERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org1/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org1/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org1/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt


BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"


infoln "Creating config transaction to add org4 to network"

# Fetch the config for the channel, writing it to config.json
fetchChannelConfig ${CHANNEL_NAME} config.json

# Modify the configuration to append the new org
set -x
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org4MSP":.[1]}}}}}' config.json ./organizations/peerOrganizations/org4.example.com/org4.json > modified_config.json
{ set +x; } 2>/dev/null

# Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to update_in_envelope.pb
createConfigUpdate ${CHANNEL_NAME} config.json modified_config.json update_in_envelope.pb

infoln "Signing config transaction"
signConfigtxAsPeerOrg update_in_envelope.pb


infoln "Submitting transaction from a different peer (peer0.org2) which also signs it"

export ORDERER_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/orderer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_ORG2_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem
export CORE_PEER_LOCALMSPID="Org2MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_org2_CA
export CORE_PEER_MSPCONFIGPATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=localhost:9051
export FABRIC_CFG_PATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/config


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=false
export CORE_PEER_TLS_CERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org2/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"
set -x
peer channel update -f update_in_envelope.pb -c ${CHANNEL_NAME} -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA"
{ set +x; } 2>/dev/null

successln "Config transaction to add org4 to network submitted"


export ORDERER_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/orderer/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_ORG4_CA=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/organizations/peerOrganizations/org4.example.com/tlsca/tlsca.org4.example.com-cert.pem
export CORE_PEER_LOCALMSPID="Org4MSP"
# export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_org4_CA
export CORE_PEER_MSPCONFIGPATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/organizations/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
export CORE_PEER_ADDRESS=localhost:12051
export FABRIC_CFG_PATH=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/config


export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=false
export CORE_PEER_TLS_CERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/home/dunne/kindpower/go/411212245@qq.com/test-fabric-samples/test-network/dp/org4/organizations/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt


BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"


# Join all the peers to the channel
infoln "Joining org4 peer to the channel..."
joinChannel 4

createAnchorPeerUpdate

updateAnchorPeer


