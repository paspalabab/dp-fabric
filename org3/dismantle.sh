. env.sh
. utils.sh

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} > /dev/null
trap "popd > /dev/null" EXIT

# Tear down running network
function networkDown() {

  rm -Rf ./channel-artifacts
  rm -Rf ./*config*.json ./*.pb ./*.tx ./log*
  rm -Rf ./organizations/peerOrganizations
  sudo rm -Rf ./organizations/fabric-ca

  COMPOSE_FILES="-f $COMPOSE_FILE_CA -f ${COMPOSE_FILE_COUCH} -f ${COMPOSE_FILE_BASE} -f ${COMPOSE_FILE_DOCKER_ENV} "

  if [ "${CONTAINER_CLI}" == "docker" ]; then
    DOCKER_SOCK=$DOCKER_SOCK ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} down --volumes --remove-orphans
  else
    fatalln "Container CLI  ${CONTAINER_CLI} not supported"
  fi

}

networkDown