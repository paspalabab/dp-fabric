rm -f docker-compose-peer.yaml temp.yml
( echo "cat <<EOF >docker-compose-peer.yaml";
  cat ${PEER_SCRIPTS_PATH}/template-docker-compose-peer.yaml;
) >temp.yml
. temp.yml
rm temp.yml

rm -f compose-peer.yaml temp.yml
( echo "cat <<EOF >compose-peer.yaml";
  cat ${PEER_SCRIPTS_PATH}/template-compose-peer.yaml;
) >temp.yml
. temp.yml
rm temp.yml

rm -f compose-couch.yaml temp.yml
( echo "cat <<EOF >compose-couch.yaml";
  cat ${PEER_SCRIPTS_PATH}/template-compose-couch.yaml;
) >temp.yml
. temp.yml
rm temp.yml