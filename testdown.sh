cd org1/
./dismantle.sh || true
cd ../org2/
./dismantle.sh || true
cd ../org3/
./dismantle.sh || true
cd ../org4/
./dismantle.sh || true
cd ../orderer/
./dismantle.sh || true
cd ..
cd org1/
./dismantle.sh || true
cd ../org2/
./dismantle.sh || true
cd ../org3/
./dismantle.sh || true
cd ../org4/
./dismantle.sh || true
cd ../orderer/
./dismantle.sh || true
cd ..
docker ps