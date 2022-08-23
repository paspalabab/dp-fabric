set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
# declare -a ordererlist=("orderer1" "orderer2" "orderer3" "orderer4" "orderer5" )
declare -a orglist=("org6")
declare -a existingOrglist=("org1" "org2" "org3" "org4" "org5")
{ set +x; } 2>/dev/null

for each_org_config_path in "${existingOrglist[@]}"
do
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   if [ ${each_org_config_path} = "org1" ]; then
       echo "fetch config through node peer of ${each_org_config_path}"
       ./fetchCurChanConfig.sh ${HOME_FOR_SETUP}/configtx
       echo "Creating config transaction to add new org to network through node peer of ${each_org_config_path}"
       ./createAndSignNewOrgConfig.sh --genupconfig true --upconfigpath ${HOME_FOR_SETUP}/configtx/update_in_envelope.pb --newmsp Org6MSP --newdef ${HOME_FOR_SETUP}/org6/organizations/peerOrganizations/org6.example.com/Org6.json --original-config ${HOME_FOR_SETUP}/configtx/cur_chan_config.json --modified-config ${HOME_FOR_SETUP}/configtx/modified_config.json
   elif [ ${each_org_config_path} = "org5" ]; then
       echo "submit and update channel config through node peer of ${each_org_config_path}"
       ./updateConfigtx.sh ${HOME_FOR_SETUP}/configtx/update_in_envelope.pb 
   else
       echo "sign the updated channel config by node peer of ${each_org_config_path}"
       ./createAndSignNewOrgConfig.sh --upconfigpath ${HOME_FOR_SETUP}/configtx/update_in_envelope.pb
   fi
done

sleep 3
for each_org_config_path in "${orglist[@]}"
do
   echo "check peer and channel block info though node peer of  ${each_org_config_path}"
   cd ${HOME_FOR_SETUP}/${each_org_config_path}
   ./query.sh
   ./fetchCurChanConfig.sh ${HOME_FOR_SETUP}/configtx
done