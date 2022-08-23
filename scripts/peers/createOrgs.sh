function createOrgs() {
  infoln "Enrolling the CA admin"

  set -x
  fabric-ca-client enroll \
  -u https://${CA_ADMIN_NAME}:${CA_ADMIN_PW}@${CA_SERVICE_ADDRESS} \
  --caname ${FABRIC_CA_NAME} \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  echo "NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/${CA_SERVICE_IP}-${CA_SERVICE_PORT}-fabric-ca.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/${CA_SERVICE_IP}-${CA_SERVICE_PORT}-fabric-ca.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/${CA_SERVICE_IP}-${CA_SERVICE_PORT}-fabric-ca.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/${CA_SERVICE_IP}-${CA_SERVICE_PORT}-fabric-ca.pem
    OrganizationalUnitIdentifier: orderer"  \
  > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy org1's CA cert to org1's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp ${FABRIC_CA_CERT} \
  "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"

  # Copy org1's CA cert to org1's /tlsca directory (for use by clients)
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp ${FABRIC_CA_CERT} \
  "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.${THIS_ORG_HOST}-cert.pem"

  # Copy org1's CA cert to org1's /ca directory (for use by clients)
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp ${FABRIC_CA_CERT} \
  "${FABRIC_CA_CLIENT_HOME}/ca/ca.${THIS_ORG_HOST}-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register \
  --caname ${FABRIC_CA_NAME} \
  --id.name ${CA_REG_PEER_NAME} --id.secret ${CA_REG_PEER_PW} \
  --id.type peer \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register \
  --caname ${FABRIC_CA_NAME} \
  --id.name ${CA_REG_PEER_USER1_NAME} --id.secret ${CA_REG_PEER_USER1_PW} \
  --id.type client \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register \
  --caname ${FABRIC_CA_NAME} \
  --id.name ${CA_REG_PEER_ADMIN_NAME} --id.secret ${CA_REG_PEER_ADMIN_PW} \
  --id.type admin \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll \
  -u https://${CA_REG_PEER_NAME}:${CA_REG_PEER_PW}@${CA_SERVICE_IP}:${CA_SERVICE_PORT} \
  --caname ${FABRIC_CA_NAME} \
  -M "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/msp" \
  --csr.hosts ${CA_REG_PEER_HOST} \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" \
  "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll \
  -u https://${CA_REG_PEER_NAME}:${CA_REG_PEER_PW}@${CA_SERVICE_IP}:${CA_SERVICE_PORT} \
  --caname ${FABRIC_CA_NAME} \
  -M "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls" \
  --enrollment.profile tls \
  --csr.hosts ${CA_REG_PEER_HOST} --csr.hosts localhost \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the peer's tls directory that are referenced by peer startup config
  cp "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls/tlscacerts/"* \
  "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls/signcerts/"* \
  "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls/keystore/"* \
  "${FABRIC_CA_CLIENT_HOME}/peers/${CA_REG_PEER_HOST}/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll \
  -u https://${CA_REG_PEER_USER1_NAME}:${CA_REG_PEER_USER1_PW}@${CA_SERVICE_IP}:${CA_SERVICE_PORT} \
  --caname ${FABRIC_CA_NAME} \
  -M "${FABRIC_CA_CLIENT_HOME}/users/User1@${THIS_ORG_HOST}/msp" \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" \
  "${FABRIC_CA_CLIENT_HOME}/users/User1@${THIS_ORG_HOST}/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll \
  -u https://${CA_REG_PEER_ADMIN_NAME}:${CA_REG_PEER_ADMIN_PW}@${CA_SERVICE_IP}:${CA_SERVICE_PORT} \
  --caname ${FABRIC_CA_NAME} \
  -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@${THIS_ORG_HOST}/msp" \
  --tls.certfiles ${FABRIC_CA_CERT}
  { set +x; } 2>/dev/null

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@${THIS_ORG_HOST}/msp/config.yaml"
}

createOrgs

# Generate channel configuration transaction
function generateOrgDefinition() {
  which configtxgen
  if [ "$?" -ne 0 ]; then
  fatalln "configtxgen tool not found. exiting"
  fi
  infoln "Generating ${HOST_NAME_ABRR} organization definition"

  set -x
  configtxgen -printOrg ${CORE_PEER_LOCALMSPID} -configPath newOrgConfigtx > ${FABRIC_CA_CLIENT_HOME}/${HOST_NAME_ABRR}.json
  res=$?
  { set +x; } 2>/dev/null
  if [ $res -ne 0 ]; then
  fatalln "Failed to generate ${HOST_NAME_ABRR} organization definition..."
  fi
}

if [ -e ${PWD}/newOrgConfigtx ]; then
    echo "new org added to existed channel, definition needed."
    generateOrgDefinition
else
    echo "original orgs, no need of definition"
fi