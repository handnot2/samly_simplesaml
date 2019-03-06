#!/bin/sh
#
# =============================================================================
# USE_SUBDOMAIN: 0 - if your application is not multi-tenant enabled
#                1 - if multi-tenant enabled (t1.mydomain, t2.mydomain etc)
# SP_DOMAIN: set to your application domain (mydomain) when USE_SUBDOMAIN=1
#            set to hostname where your app is deployed when USE_SUBDOMAIN=0
# SP_PORT: Port where your application is listening
# SP_ENTITY_ID: Typically of the form "urn:myapp:sp1". This should be same as
#               the value specified in samly service_providers config
# SP_CERT_FILE: Just the file name - NOT the path. This file MUST be placed in
#               ./setup/sp folder prior to running this script
# PSWD: Password for the demo users (check setup/templates/params.tpl)
#
# IDP_ID: This is same as the id used in samly identity_providers config
# IDP_HOST: Host name for IdP
# IDP_PORT: Where IdP listens.
#
# TIMEZONE: SimpleSAMLphp uses this in logs.
# =============================================================================

export USE_SUBDOMAIN="${USE_SUBDOMAIN:-0}"

SP_HOST=samly.howto
export SP_DOMAIN="${SP_DOMAIN:-${SP_HOST}}"
export SP_PORT="${SP_PORT:-4443}"

DEFAULT_ENTITY_ID="urn:${SP_DOMAIN}:sp"
export SP_ENTITY_ID="${SP_ENTITY_ID:-${DEFAULT_ENTITY_ID}}"

export SP_CERT_FILE="${SP_CERT_FILE:-sp.crt}"

export PSWD="${PSWD:-changeme}"

export TIMEZONE="${TIMEZONE:-America/New_York}"

export IDP_ID="${IDP_ID:-idp1}"
export IDP_HOST="${IDP_HOST:-${IDP_ID}.samly}"
export IDP_PORT="${IDP_PORT:-9091}"

export SECRET_SALT=`tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=32 count=1 2>/dev/null`

if [ "${USE_SUBDOMAIN}" = "1" ]; then
  export SP_BASEURL="https://${IDP_ID}.${SP_DOMAIN}:${SP_PORT}/sso"
  export SP_ACS_URI="/sp/consume"
  export SP_SLO_URI="/sp/logout"
else
  export SP_BASEURL="https://${SP_DOMAIN}:${SP_PORT}/sso"
  export SP_ACS_URI="/sp/consume/${IDP_ID}"
  export SP_SLO_URI="/sp/logout/${IDP_ID}"
fi

if [ "$1" = "info" ]; then
  echo "----------------------------------------------------"
  echo "IDP Metadata URL = https://${IDP_HOST}:${IDP_PORT}/simplesaml/saml2/idp/metadata.php"
  echo "Assertion Consumer Service URL (ACS) = ${SP_BASEURL}${SP_ACS_URI}"
  echo "Single Logout URL (SLO) = ${SP_BASEURL}${SP_SLO_URI}"
  echo "SP Base URL = ${SP_BASEURL}"
  echo "SP Entity ID = ${SP_ENTITY_ID}"
  echo "SP Certificate file = ${SP_CERT_FILE}"
  echo "----------------------------------------------------"

  exit 0
else
  docker-compose -p "${IDP_ID}" $*
fi
