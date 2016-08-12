#!/usr/bin/env bash

# Utility script for developers to get a certificate from a ca-server
# use like getcert.sh $HOME/.certs http://10.20.30.40:8080 (where that is the IP of your CA server)

CERT_DIR=$1
CA=$2

set -e

mkdir -p ${CERT_DIR}
curl -L ${CA}/cacert/ca.pem --output ${CERT_DIR}/ca.pem
openssl genrsa -out ${CERT_DIR}/key.pem 2048
openssl req  -new -key ${CERT_DIR}/key.pem -days 1825 -out ${CERT_DIR}/csr.pem -subj "/CN=$(hostname)"
curl -X POST --data-binary @${CERT_DIR}/csr.pem ${CA}/sign > ${CERT_DIR}/cert.pem
