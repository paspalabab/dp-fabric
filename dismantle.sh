set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CA_CLIENT_HOME_RALETIVE_PATH=organizations
ORDERER_ADMIN_TLS_CERT_RALETIVE_PATH=${FABRIC_CA_CLIENT_HOME_RALETIVE_PATH}/orderers/tls/server.crt
FABRIC_CONFIGTX_PATH=${HOME_FOR_SETUP}/configtx
declare -a ordererlist=("orderer1" "orderer2" "orderer3" "orderer4" "orderer5" )
declare -a orglist=("org1" "org2" "org3" "org4" "org5" "org6")

{ set +x; } 2>/dev/null

# destruct all docker components
i=0
while [ $i -le 2 ]
do
  cd fabric-ca
  ./dismantle.sh || true

  for each_orderer_config_path in "${ordererlist[@]}"
  do
    cd ${HOME_FOR_SETUP}/${each_orderer_config_path}
    ./dismantle.sh || true
  done
  
  for each_org_config_path in "${orglist[@]}"
  do
    cd ${HOME_FOR_SETUP}/${each_org_config_path}
    ./dismantle.sh || true
  done
  ((i++))
done

# delete unused files
for each_orderer_config_path in "${ordererlist[@]}"
do
  rm -rf ${HOME_FOR_SETUP}/${each_orderer_config_path}/*.yaml
  rm -rf ${HOME_FOR_SETUP}/${each_orderer_config_path}/setup*.sh
  rm -rf ${HOME_FOR_SETUP}/${each_orderer_config_path}/setchan*.sh
  rm -rf ${HOME_FOR_SETUP}/${each_orderer_config_path}/dismantle*.sh
done

for each_org_config_path in "${orglist[@]}"
do
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/*.yaml
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/setup.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/query.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/dismantle.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/joinchan.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/fetchCurChanConfig.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/generateOrgDefinition.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/createAndSignNewOrgConfig.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/updateConfigtx.sh
  rm -rf ${HOME_FOR_SETUP}/${each_org_config_path}/removePeer.sh
done

rm -rf ${HOME_FOR_SETUP}/configtx

docker ps

