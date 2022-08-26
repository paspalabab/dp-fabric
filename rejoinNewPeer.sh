set -x
HOME_FOR_SETUP=${PWD}
FABRIC_CLI_WORK_HOME=/opt/gopath/src/github.com/hyperledger/fabric/home
{ set +x; } 2>/dev/null

set -x
sudo cp $HOME_FOR_SETUP/host6/org6/organizations/peerOrganizations/org6.example.com/Org6.json $HOME_FOR_SETUP/host1/configtx

cd $HOME_FOR_SETUP/host1
./genNewConfig.sh

sequence=2
set -x
while [ $sequence -le 5 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   sudo cp  $HOME_FOR_SETUP/host$(( $sequence - 1 ))/configtx/update_in_envelope.pb  $HOME_FOR_SETUP/host$sequence/configtx
   cd $HOME_FOR_SETUP/host$sequence
   ./signNewConfig.sh
   sequence=$(( $sequence + 1 ))
done
{ set +x; } 2>/dev/null

cd $HOME_FOR_SETUP/host5
./upNewConfig.sh

sleep5

echo "check peer and channel block info though node peer of org6"
docker exec fabric-cli-fabric-host6 /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org6; pwd; ./query.sh; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx"

echo "check peer and channel block info though node peer of org1"
docker exec fabric-cli-fabric-host1 /bin/sh -c "cd ${FABRIC_CLI_WORK_HOME}/org1; pwd; ./query.sh; ./fetchCurChanConfig.sh ${FABRIC_CLI_WORK_HOME}/configtx"


