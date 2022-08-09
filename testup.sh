cd orderer/
./setup.sh
cd ../org1/
./setup.sh
cd ../org2/
./setup.sh
cd ../org3/
./setupNewOrg.sh
cd ../org4/
./setupNewOrg.sh
cd ../orderer/
./setchan.sh
sleep 3
cd ../org1/
cp -r ../orderer/channel-artifacts .
./joinchan.sh
cd ../org2/
cp -r ../orderer/channel-artifacts .
./joinchan.sh
cd ../org3/
cp -r ../orderer/channel-artifacts .
./joinchanbyNewOrg.sh
cd ../org4/
cp -r ../orderer/channel-artifacts .
./joinchanbyNewOrg.sh
cd ..