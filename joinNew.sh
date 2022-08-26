set -x
HOME_FOR_SETUP=${PWD}
{ set +x; } 2>/dev/null

cd $HOME_FOR_SETUP/host6
./setnewPeer.sh

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

sudo cp -r $HOME_FOR_SETUP/host5/configtx/channel-artifacts $HOME_FOR_SETUP/host6/configtx/ && sudo chmod -R 777 $HOME_FOR_SETUP/host6/configtx/
mkdir -p $HOME_FOR_SETUP/host6/orderer1/organizations/tlsca
sudo cp -r $HOME_FOR_SETUP/host1/orderer1/organizations/tlsca/tlsca.example.com-cert.pem $HOME_FOR_SETUP/host6/orderer1/organizations/tlsca

cd $HOME_FOR_SETUP/host6
./joinNewPeer.sh
