#!/bin/sh

SRC_DIR="/setup"
GEN_DIR="/sspdv"

SSP_DIR="/srv/simplesaml"

mkdir -p ${GEN_DIR}/cert
mkdir -p ${GEN_DIR}/nginx/conf.d
touch ${GEN_DIR}/nginx/conf.d/site.conf

if [ ! -f ${GEN_DIR}/cert/server.crt ];
then
  C="US"
  ST="Midlands"
  L="Safeville"
  O="ID Federation"
  OU="Department of Identities"
  CN="my.idp"
  SUBJ="/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=${CN}"

  echo "Generating IDP Certificate ..."
  openssl req -new -x509 -sha256 -days 365 -nodes \
    -newkey rsa:4096 \
    -out ${GEN_DIR}/cert/server.crt \
    -keyout ${GEN_DIR}/cert/server.pem \
    -subj "${SUBJ}"
fi

if [ -d ${SRC_DIR}/sp ];
then
  echo "Copying SP cert ..."
  cp -r ${SRC_DIR}/sp ${SSP_DIR}/cert/
fi
cp -f ${GEN_DIR}/cert/server.crt ${SSP_DIR}/cert/
cp -f ${GEN_DIR}/cert/server.pem ${SSP_DIR}/cert/

for i in `cat ${SRC_DIR}/templates/nginx.config`
do
  f=`echo $i | sed 's/\.tpl$//' -`
  twit ${SRC_DIR}/templates/${i} ${GEN_DIR}/nginx/conf.d/${f} \
    -p ${SRC_DIR}/params/defaults.yml -p ${SRC_DIR}/params/params.yml -n
done

for i in `cat ${SRC_DIR}/templates/ssp.config`
do
  f=`echo $i | sed 's/\.tpl$//' -`
  twit ${SRC_DIR}/templates/${i} ${SSP_DIR}/config/${f} \
    -p ${SRC_DIR}/params/defaults.yml -p ${SRC_DIR}/params/params.yml -n
done

for i in `cat ${SRC_DIR}/templates/ssp.metadata`
do
  f=`echo $i | sed 's/\.tpl$//' -`
  twit ${SRC_DIR}/templates/${i} ${SSP_DIR}/metadata/${f} \
    -p ${SRC_DIR}/params/defaults.yml -p ${SRC_DIR}/params/params.yml -n
done

touch ${SSP_DIR}/modules/exampleauth/default-enable
