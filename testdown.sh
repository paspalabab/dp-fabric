set -x
HOME_FOR_SETUP=${PWD}
{ set +x; } 2>/dev/null

sequence=1
while [ $sequence -le 6 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   cd $HOME_FOR_SETUP/host$sequence
   sequence=$(( $sequence + 1 ))
   ./dismantle.sh
done

sequence=1
while [ $sequence -le 6 ]
do
   if [[ ! -e $HOME_FOR_SETUP/host$sequence ]] ; then
       echo "$HOME_FOR_SETUP/host$sequence is not there, aborting."
       exit
   fi
   rm -rf $HOME_FOR_SETUP/host$sequence/dp-planet-chaincode-go
   sequence=$(( $sequence + 1 ))
done