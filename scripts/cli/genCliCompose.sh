rm -f compose-cli.yaml temp.yml
( echo "cat <<EOF >compose-cli.yaml";
  cat ${CLI_SCRIPTS_PATH}/template-compose-cli.yaml;
) >temp.yml
. temp.yml
rm temp.yml