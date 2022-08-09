. env.sh
. utils.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT
# fetchChannelConfig <org> <channel_id> <output_json>
# Writes the current channel config for a given channel to a JSON file
# NOTE: this must be run in a CLI container since it requires configtxlator
fetchChannelConfig() {
  ORG=$1
  CHANNEL=$2
  OUTPUT=$3

  infoln "Fetching the most recent configuration block for the channel"
  set -x
  peer channel fetch config config_block.pb -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL --tls --cafile "$ORDERER_CA"
  { set +x; } 2>/dev/null

  infoln "Decoding config block to JSON and isolating config to ${OUTPUT}"
  set -x
  configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json
  jq .data.data[0].payload.data.config config_block.json >"${OUTPUT}"
  { set +x; } 2>/dev/null

  set -x
  peer channel list -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com  --tls --cafile "$ORDERER_CA"
  res=$?
  { set +x; } 2>/dev/null

  set -x
  peer channel getinfo -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com  -c $CHANNEL  --tls --cafile "$ORDERER_CA"
  res=$?
  { set +x; } 2>/dev/null
}

fetchChannelConfig 3 $CHANNEL_NAME ${CORE_PEER_LOCALMSPID}config.json