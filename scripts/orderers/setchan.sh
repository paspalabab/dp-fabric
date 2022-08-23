. env.sh
. ${ORDERER_SCRIPTS_PATH}/globalOrdererEnv.sh
. ${COMMON_SCRIPTS_PATH}/utils.sh
. ${ORDERER_SCRIPTS_PATH}/createChanAndGenBlock.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  --cfgxpath )
    CC_CFGX_PATH="$2"
	echo ${CC_CFGX_PATH}
    shift
    ;;
  --genblockpath )
    CC_GENESIS_BLOCK_PATH="$2"
	echo ${CC_GENESIS_BLOCK_PATH}
    shift
    ;;
  * )
    errorln "Unknown flag: $key"
    exit 1
    ;;
  esac
  shift
done


if [ -z "$CC_GENESIS_BLOCK_PATH" ] 
then
      echo "genesis file path not designated"
	  exit 1
fi

if [ ! -z "$CC_CFGX_PATH" ] 
then
    echo "the configtx path: ${CC_CFGX_PATH}"
	echo "the destination path to hold genesis block: ${CC_GENESIS_BLOCK_PATH}"
	## Create channel genesis block
    infoln "Generating channel genesis block '${CHANNEL_NAME}.block'"
	createChannelGenesisBlock
else
    echo "no genesis block need to be generated"	
fi

## Create channel
infoln "Creating channel ${CHANNEL_NAME}"
createChannel
successln "Channel '$CHANNEL_NAME' created"