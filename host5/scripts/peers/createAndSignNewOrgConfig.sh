. env.sh
. ${PEER_SCRIPTS_PATH}/commonEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${PEER_SCRIPTS_PATH}/channel.sh


while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  --genupconfig )
    ifGenUpConfig="true"
	  echo ${ifGenUpConfig}
    shift
    ;;
  --upconfigpath )
    updatedChanConfig="$2"
	echo ${updatedChanConfigs}
    shift
    ;;
  --newmsp )
    newOrgMSP="$2"
	echo ${newOrgMSP}
    shift
    ;;
  --newdef )
    newOrgDef="$2"
	echo ${newOrgDef}
    shift
    ;;
  --original-config )
    originalChanConfig="$2"
	echo ${originalChanConfig}
    shift
    ;;
  --modified-config )
    modifiedChanConfig="$2"
	echo ${modifiedChanConfig}
    shift
    ;;
  * )
    errorln "Unknown flag: $key"
    exit 1
    ;;
  esac
  shift
done


# generate updated configtx  file
if [ ! -z $ifGenUpConfig ]
then
    # Fetch the config for the channel, writing it to config.json
    fetchChannelConfig ${CHANNEL_NAME} $originalChanConfig

    # Modify the configuration to append the new org
    set -x
    jq -s ".[0] * {"channel_group":{"groups":{"Application":{"groups": {"$newOrgMSP":.[1]}}}}}" $originalChanConfig $newOrgDef > $modifiedChanConfig
    { set +x; } 2>/dev/null


    # Compute a config update, based on the differences between config.json and modified_config.json, write it as a transaction to update_in_envelope.pb
    createConfigUpdate ${CHANNEL_NAME} $originalChanConfig $modifiedChanConfig $updatedChanConfig
else
    echo "no need to gen updated config"
fi

# sign updated configtx file
set -x
peer channel signconfigtx -f "${updatedChanConfig}"
{ set +x; } 2>/dev/null