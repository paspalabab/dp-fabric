rm -f compose-ca-cli.yaml temp.yml
( echo "cat <<EOF >compose-ca-cli.yaml";
  cat ${CLI_SCRIPTS_PATH}/template-compose-ca-cli.yaml;
) >temp.yml
. temp.yml
rm temp.yml