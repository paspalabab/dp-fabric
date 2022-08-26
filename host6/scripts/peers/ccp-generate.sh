function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ${PEER_SCRIPTS_PATH}/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ${PEER_SCRIPTS_PATH}/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}


infoln "Generating CCP files for Org"

ORG=${ORG_NUMBER}
P0PORT=${PEER_SERVICE_PORT}
CAPORT=${CA_SERVICE_PORT}
PEERPEM=${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.${THIS_ORG_HOST}-cert.pem
CAPEM=${FABRIC_CA_CLIENT_HOME}/ca/ca.${THIS_ORG_HOST}-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${FABRIC_CA_CLIENT_HOME}/connection-${THIS_ORG_HOST}.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ${FABRIC_CA_CLIENT_HOME}/connection-${THIS_ORG_HOST}.yaml