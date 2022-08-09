. env.sh

set -x
osnadmin channel list --channelID $CHANNEL_NAME -o localhost:7053 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
res=$?
{ set +x; } 2>/dev/null