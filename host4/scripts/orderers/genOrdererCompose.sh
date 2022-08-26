rm -f compose-orderer.yaml temp.yml
( echo "cat <<EOF >compose-orderer.yaml";
  cat ${ORDERER_SCRIPTS_PATH}/template-compose-orderer.yaml;
) >temp.yml
. temp.yml
rm temp.yml