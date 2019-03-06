#!/bin/sh
export IDP_ID="${IDP_ID:-idp1}"
export IDP_HOST="${IDP_HOST:-${IDP_ID}.samly}"
export IDP_PORT="${IDP_PORT:-8082}"
export SECRET_SALT=`tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=32 count=1 2>/dev/null`
export PSWD="${PSWD:-changeme}"
export SP_DOMAIN="${SP_DOMAIN:-samly.howto}"
export SP_PORT="${SP_PORT:-4443}"
DEFAULT_ENTITY_ID="urn:${SP_DOMAIN}:sp"
export SP_ENTITY_ID="${SP_ENTITY_ID:-${DEFAULT_ENTITY_ID}}"
export SP_CERT_FILE="${SP_CERT_FILE:-sp.crt}"
export USE_SUBDOMAIN="${USE_SUBDOMAIN:-0}"

if [ "${USE_SUBDOMAIN}" = "1" ]; then
  export SP_BASEURL="https://${IDP_ID}.${SP_DOMAIN}:${SP_PORT}/sso"
  export SP_ACS_URI="/sp/consume"
  export SP_SLO_URI="/sp/logout"
else
  export SP_BASEURL="https://${SP_DOMAIN}:${SP_PORT}/sso"
  export SP_ACS_URI="/sp/consume/${IDP_ID}"
  export SP_SLO_URI="/sp/logout/${IDP_ID}"
fi

# echo "----------------------------------------------------"
# echo "IDP Metadata URL = https://${IDP_HOST}:${IDP_PORT}/simplesaml/saml2/idp/metadata.php"
# echo "Assertion Consumer Service URL (ACS) = ${SP_BASEURL}${SP_ACS_URI}"
# echo "Single Logout URL (SLO) = ${SP_BASEURL}${SP_SLO_URI}"
# echo "SP Entity ID = ${SP_ENTITY_ID}"
# echo "SP Certificate file = ${SP_CERT_FILE}"
# echo "----------------------------------------------------"

docker-compose -p "${IDP_ID}" $*
