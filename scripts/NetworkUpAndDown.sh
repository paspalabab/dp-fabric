function networkUp() {
  set -x
  DOCKER_SOCK="${DOCKER_SOCK}" ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} up -d 2>&1
  { set +x; } 2>/dev/null

  $CONTAINER_CLI ps
  if [ $? -ne 0 ]; then
    fatalln "Unable to start network"
  fi
}

# Tear down running network
function networkDown() {
  set -x
  sudo rm -Rf ${FILES_LIST_FOR_NETDOWN_CLEAR}
  { set +x; } 2>/dev/null

  if [ "${CONTAINER_CLI}" == "docker" ]; then
    set -x
    DOCKER_SOCK=$DOCKER_SOCK ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} down --volumes --remove-orphans
    { set +x; } 2>/dev/null
  else
    fatalln "Container CLI  ${CONTAINER_CLI} not supported"
  fi
}