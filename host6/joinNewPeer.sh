set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
. ${HOME_FOR_SETUP}/host.sh
{ set +x; } 2>/dev/null
 
# let peers join the channel
for each_org_config_path in "${orglist[@]}"
do
   docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./joinchan.sh"
done

sleep 3
for each_org_config_path in "${orglist[@]}"
do
   echo "check peer and channel block info though node peer of  ${each_org_config_path}"
   docker exec $FABRIC_CLI /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/${each_org_config_path}; pwd; ./query.sh; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx"
done