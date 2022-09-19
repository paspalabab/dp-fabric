set -x
HOME_FOR_SETUP=${PWD}
{ set +x; } 2>/dev/null

sequence=1
while [ $sequence -le 5 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cd $HOME_FOR_SETUP/host$sequence
   sequence=$(( $sequence + 1 ))
   ./prepare.sh
done

sequence=1
while [ $sequence -le 5 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cd $HOME_FOR_SETUP/host$sequence
   sequence=$(( $sequence + 1 ))
   ./networkUp.sh
done

sequence=1
while [ $sequence -le 5 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cp -r $HOME_FOR_SETUP/host$sequence/configtx/cryptogen/orderer$sequence \
   $HOME_FOR_SETUP/host1/configtx/cryptogen/
   cp -r $HOME_FOR_SETUP/host$sequence/configtx/cryptogen/peerorg$sequence \
   $HOME_FOR_SETUP/host1/configtx/cryptogen/
   sequence=$(( $sequence + 1 ))
done

sequence=1
while [ $sequence -le 1 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cd $HOME_FOR_SETUP/host$sequence
   sequence=$(( $sequence + 1 ))
   ./creatchain.sh
done

sequence=2
while [ $sequence -le 5 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   sudo cp -r $HOME_FOR_SETUP/host1/configtx/* \
   $HOME_FOR_SETUP/host$sequence/configtx
   cd $HOME_FOR_SETUP/host$sequence
   ./creatchain.sh
   sequence=$(( $sequence + 1 ))
done

sequence=1
while [ $sequence -le 5 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cd $HOME_FOR_SETUP/host$sequence
   sequence=$(( $sequence + 1 ))
   ./joinchain.sh
done

sequence=1
while [ $sequence -le 6 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cp -r $HOME_FOR_SETUP/dp-planet-chaincode-go $HOME_FOR_SETUP/host$sequence
   sequence=$(( $sequence + 1 ))
done