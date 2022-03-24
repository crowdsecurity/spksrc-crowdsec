# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
#

PATH="${SYNOPKG_PKGDEST}/sbin:${SYNOPKG_PKGDEST}/usr/sbin:${PATH}"

# Package
PACKAGE="crowdsec"
DNAME="CrowdSec"
PKG_DIR="/var/packages/${PACKAGE}"

ETC_DIR="${PKG_DIR}/etc"
HOME_DIR="${PKG_DIR}/home"
INSTALL_DIR="${PKG_DIR}/target"
TMP_DIR="${PKG_DIR}/tmp"
VAR_DIR="${PKG_DIR}/var"
SHARE_DIR="${INSTALL_DIR}/share/crowdsec"

DEFAULT_CONFIGDIR="/var/packages/crowdsec/etc"
DEFAULT_DATADIR="${DEFAULT_CONFIGDIR}/data"
PLUGINSDIR="${INSTALL_DIR}/lib/crowdsec/plugins/"

# Binaries
CROWDSEC="${INSTALL_DIR}/usr/sbin/crowdsec"
CSCLI="${INSTALL_DIR}/usr/sbin/cscli"

# Others
CONFIGDIR="${ETC_DIR}"
CFG_FILE="${CONFIGDIR}/config.yaml"
LOCALAPI="${CONFIGDIR}/local_api_credentials.yaml"
ONLINEAPI="${CONFIGDIR}/online_api_credentials.yaml"
HUBDIR="${CONFIGDIR}/hub"
DATA_DIR="${CONFIGDIR}/data"
DB_PATH="${DATA_DIR}/crowdsec.db"

# Service

SVC_CWD="${INSTALL_DIR}"
HOME="${INSTALL_DIR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

LAPI_URL="127.0.0.1"
LAPI_PORT="8888"

SERVICE_COMMAND="${CROWDSEC} -c ${CFG_FILE}"

##LAPI_PORT_TITLE = $(DISPLAY_NAME) (API)

fix_perms ()
{
	# Fix permissions
	echo "Fix permissions: ${PACKAGE}"
	chmod ug+Xrw "${PKG_DIR}" -Rf
	chmod ug+Xrw "${CONFIGDIR}" -Rf
	chmod ug+Xrw "${DATA_DIR}" -Rf
	chmod ug+Xrw "${TMP_DIR}" -Rf
	chown sc-crowdsec:sc-crowdsec "${PKG_DIR}" -Rf
	chown sc-crowdsec:sc-crowdsec "${CONFIGDIR}" -Rf
	chown sc-crowdsec:sc-crowdsec "${DATA_DIR}" -Rf
	chown sc-crowdsec:sc-crowdsec "${TMP_DIR}" -Rf
}

patch_nginx ()
{
	NGINX_MUSTACHE="/usr/syno/share/nginx/nginx.mustache"
#-	access_log  off;
#+	#access_log  off;
	sed -e "s| access_log  off;|#access_log  off;|g" -i "${CFG_FILE}"
#-	#access_log syslog:server=unix:/dev/log,facility=local7,tag=nginx_access,nohostname main;
#+	access_log syslog:server=unix:/dev/log,facility=local7,tag=nginx_access,nohostname main;
	sed -e "s|#access_log syslog:server=unix:/dev/log,facility=local7,tag=nginx_access,nohostname main;| access_log syslog:server=unix:/dev/log,facility=local7,tag=nginx_access,nohostname main;|g" -i "${CFG_FILE}"
}

service_prepare ()
{
	fix_perms
	# Create the config file on demand
	if [ ! -e "${CFG_FILE}" ]; then
		echo "Create initial configs directory: ${CONFIGDIR}"
		echo "$RSYNC --ignore-existing ${INSTALL_DIR}/etc/crowdsec/. ${CONFIGDIR}/."
		$RSYNC --ignore-existing "${INSTALL_DIR}/etc/crowdsec/." "${CONFIGDIR}/."
		chmod ug+Xrw "${CONFIGDIR}" -R
	fi

	# Create data dir & permissions if needed
	if [ ! -d "${DATA_DIR}" ]; then
		echo "Create initial run directory: ${DATA_DIR}"
		mkdir -m 0775 -p "${DATA_DIR}"
		chmod ug+Xrw ${DATA_DIR} -R
	fi

	# Link data dirs & permissions if needed
	if [ ! -L "${SHARE_DIR}" ]; then
		if [ -d "${SHARE_DIR}" ]; then
			echo "Create initial link to default data directory: ${SHARE_DIR} -> ${DATA_DIR}"

			# Remove remaining directory
			$RM "${SHARE_DIR}"

			# Link from old directory
			echo "$LN -Ts ${DATA_DIR} ${SHARE_DIR}"
			$LN -Ts "${DATA_DIR}" "${SHARE_DIR}"
		fi
	fi

	# Create run dir & permissions if needed
	if [ ! -d "${TMP_DIR}/run" ]; then
		echo "Create initial run directory: ${TMP_DIR}/run"
		mkdir -m 0775 -p "${TMP_DIR}/run"
		chmod ug+Xrw "${TMP_DIR}/run" -R
	fi

	# Create log dir & permissions if needed
	if [ ! -d "${TMP_DIR}/log" ]; then
		echo "Create initial log directory: ${TMP_DIR}/log"
		mkdir -m 0775 -p "${TMP_DIR}/log"
		chmod ug+Xrw "${TMP_DIR}/log" -R
	fi

	# Create hub dir & permissions if needed
	if [ ! -d "${HUBDIR}" ]; then
		echo "Create initial hub directory: ${HUBDIR}"
		mkdir -m 0775 -p "${HUBDIR}"
		chmod ug+Xrw "${HUBDIR}" -R
	fi

	# Prepare the config file if needed
	if [ -e "${CFG_FILE}" ]; then
		echo "Modify initial config file: ${CFG_FILE}"

		sed -i "s,^\(\s*pid_dir\s*:\s*\).*\$,\1${TMP_DIR}/run," "${CFG_FILE}"
		sed -i "s,^\(\s*log_dir\s*:\s*\).*\$,\1${TMP_DIR}/log," "${CFG_FILE}"
		sed -i "s,^\(\s*config_dir\s*:\s*\).*\$,\1${CONFIGDIR}," "${CFG_FILE}"
		sed -i "s,^\(\s*data_dir\s*:\s*\).*\$,\1${DATA_DIR}," "${CFG_FILE}"
		sed -i "s,^\(\s*db_path\s*:\s*\).*\$,\1${DB_PATH}," "${CFG_FILE}"
		sed -i "s,^\(\s*simulation_path\s*:\s*\).*\$,\1${CONFIGDIR}/simulation.yaml," "${CFG_FILE}"
		sed -i "s,^\(\s*hub_dir\s*:\s*\).*\$,\1${HUBDIR}," "${CFG_FILE}"
		sed -i "s,^\(\s*index_path\s*:\s*\).*\$,\1${HUBDIR}/.index.json," "${CFG_FILE}"
		sed -i "s,^\(\s*notification_dir\s*:\s*\).*\$,\1${CONFIGDIR}/notifications/," "${CFG_FILE}"
		sed -i "s,^\(\s*plugin_dir\s*:\s*\).*\$,\1${PLUGINSDIR}," "${CFG_FILE}"
#		sed -i "s,^\(\s*acquisition_path\s*:\s*\).*\$,\1${CONFIGDIR}/acquis.yaml," "${CFG_FILE}"
		sed -e "s,acquisition_path:,acquisition_dir:,g" -i "${CFG_FILE}"
		sed -i "s,^\(\s*acquisition_dir\s*:\s*\).*\$,\1${CONFIGDIR}/acquis.d/," "${CFG_FILE}"

		sed -i "s,^\(\s*profiles_path\s*:\s*\).*\$,\1${CONFIGDIR}/profiles.yaml," "${CFG_FILE}"
		sed -i "s,^\(\s*console_path\s*:\s*\).*\$,\1${CONFIGDIR}/console.yaml," "${CFG_FILE}"

		sed -e "s,credentials_path: /etc/crowdsec/local_api_credentials.yaml,credentials_path: ${LOCALAPI},g" -i "${CFG_FILE}"
		sed -e "s,credentials_path: /etc/crowdsec/online_api_credentials.yaml,credentials_path: ${ONLINEAPI},g" -i "${CFG_FILE}"

		sed -i "s,^\(\s*listen_uri\s*:\s*\).*\$,\1${LAPI_URL}:${LAPI_PORT}," "${CFG_FILE}"
		sed -i "s,^\(\s*url\s*:\s*\).*\$,\1http://${LAPI_URL}:${LAPI_PORT}," "${LOCALAPI}"
	fi

	if grep -q "login:" "${LOCALAPI}"; then
		echo "INFO: local API already registered…"
	else
	# api register
		"${CSCLI}" -c "${CFG_FILE}" machines add --force "$(cat /etc/machine-id)" -a -f "${LOCALAPI}" || echo "ERROR: unable to add machine to the local API!"
	fi

	if grep -q "login:" ${ONLINEAPI}; then
		echo "INFO: online API already registered…"
	else
		"${CSCLI}" -c "${CFG_FILE}" capi register -f "${ONLINEAPI}" || echo "ERROR: unable to register to the Central API!"
	fi

	fix_perms

# FIXME: Do this only if hub is not already up to date !
	"${CSCLI}" -c "${CFG_FILE}" hub update && \
	"${CSCLI}" -c "${CFG_FILE}" collections install crowdsecurity/linux && \
	"${CSCLI}" -c "${CFG_FILE}" collections install crowdsecurity/nginx && \
	"${CSCLI}" -c "${CFG_FILE}" collections install crowdsecurity/iptables && \
	"${CSCLI}" -c "${CFG_FILE}" collections install crowdsecurity/synology-dsm && \
	"${CSCLI}" -c "${CFG_FILE}" parsers install crowdsecurity/whitelists && \
	"${CSCLI}" -c "${CFG_FILE}" hub upgrade

	fix_perms
}

service_clean ()
{
	# Clean link data dirs & permissions
	if [ -L "${SHARE_DIR}" ]; then
		echo "Remove link to default data directory: ${SHARE_DIR}"
		$RM "${SHARE_DIR}"
	fi
}

fix_runas_root ()
{
##	sed -i "s/package/root/" "/var/packages/${PACKAGE}/conf/privilege"
}

service_postinst ()
{
#	if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then	# Create data dir & permissions if needed
		service_prepare
#	fi
	fix_runas_root
	patch_nginx
}

service_postupgrade ()
{
	service_prepare
	fix_runas_root
	patch_nginx
}

service_prestart ()
{
	service_prepare
	fix_runas_root
	patch_nginx
}

service_postuninst ()
{
	service_clean
}

