#!/usr/bin/env ksh
SOURCE_DIR=$(dirname $0)
ZABBIX_DIR=/etc/zabbix

mkdir -p ${ZABBIX_DIR}/scripts/agentd/zapgix
cp -r ${SOURCE_DIR}/zapgix/sql ${ZABBIX_DIR}/scripts/agentd/zapgix/
cp ${SOURCE_DIR}/zapgix/zapgix.conf.example ${ZABBIX_DIR}/scripts/agentd/zapgix/
cp ${SOURCE_DIR}/zapgix/zapgix.sh ${ZABBIX_DIR}/scripts/agentd/zapgix/
cp ${SOURCE_DIR}/zapgix/zabbix_agentd.conf ${ZABBIX_DIR}/zabbix_agentd.d/zapgix.conf
