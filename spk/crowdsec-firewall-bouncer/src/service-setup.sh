# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
# Copyright (C) 2021-2022 CrowdSec <crowdsec@crowdsec.net>
#

PATH="${SYNOPKG_PKGDEST}/sbin:${SYNOPKG_PKGDEST}/usr/sbin:${PATH}"

# Package
PACKAGE="crowdsec-firewall-bouncer"
DNAME="CrowdSec-Firewall-Bouncer"
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
MODULES_DIR="${INSTALL_DIR}/lib/modules/$(uname -r)"

# CrowdSec
CROWDSEC_PKGDEST="/var/packages/crowdsec"

CROWDSEC_ETCDIR="${CROWDSEC_PKGDEST}/etc"
CROWDSEC_HOMEDIR="${CROWDSEC_PKGDEST}/home"
CWD_INSTALL_DIR="${CROWDSEC_PKGDEST}/target"
CROWDSEC_TMPDIR="${CROWDSEC_PKGDEST}/tmp"
CROWDSEC_VARDIR="${CROWDSEC_PKGDEST}/var"

# Binaries
CROWDSEC="${CWD_INSTALL_DIR}/usr/sbin/crowdsec"
CSCLI="${CWD_INSTALL_DIR}/usr/sbin/cscli"
CSFWBIN="${INSTALL_DIR}/usr/sbin/crowdsec-firewall-bouncer"

# Others
CONFIGDIR="${CROWDSEC_ETCDIR}"
CFG_FILE="${CONFIGDIR}/config.yaml"
LOCALAPI="${CONFIGDIR}/local_api_credentials.yaml"
ONLINEAPI="${CONFIGDIR}/online_api_credentials.yaml"
HUBDIR="${CONFIGDIR}/hub"
DATA_DIR="${CONFIGDIR}/data"
DB_PATH="${DATA_DIR}/crowdsec.db"

# Bouncer
CSFB_INITIALCONFIG="${INSTALL_DIR}/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml"
CSFB_CUSTOMCONFIG="${CONFIGDIR}/bouncers/crowdsec-firewall-bouncer.yaml"

# Service

SVC_CWD="${INSTALL_DIR}"
HOME="${INSTALL_DIR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

LAPI_URL="127.0.0.1"
LAPI_PORT="8888"

SERVICE_COMMAND="${CSFWBIN} -c ${CSFB_CUSTOMCONFIG}"

##LAPI_PORT_TITLE = $(DISPLAY_NAME) (API)

BACKEND="iptables"
FW_BACKEND="iptables"

CSFNAME=${PACKAGE}

GenConfigApiKey ()
{
    ## Gen&ConfigApiKey
    if grep -q "{API_KEY}" "${CSFB_CUSTOMCONFIG}"; then
        API_KEY=$("${CSCLI}" -c "${CFG_FILE}" bouncers add "${CSFNAME}" -o raw)
        if [ -n "${API_KEY}" ]; then
            sed -i "s,^\(\s*api_key\s*:\s*\).*\$,\1${API_KEY}," "${CSFB_CUSTOMCONFIG}"
        else
	        echo "ERROR: NO API key registered…"
        fi
    else
        FW_BOUNCER=$("${CSCLI}" -c "${CFG_FILE}" bouncers list | grep "${CSFNAME}")
        if [ -n "${FW_BOUNCER}" ]; then
            echo "INFO: API key already registered…"
        else
            API_KEY=$(sed -rn "s,^api_key\s*:\s*([^\n]+)$,\1,p" "${CSFB_CUSTOMCONFIG}")
            if [ -n "${API_KEY}" ]; then
                NEW_API_KEY=$("${CSCLI}" -c "${CFG_FILE}" bouncers add "${CSFNAME}" -k "${API_KEY}" -o raw)
                if [ -n "${NEW_API_KEY}" ]; then
                    if [ "${NEW_API_KEY}" = "${API_KEY}" ]; then
                        echo "INFO: API key already registered but bouncer re-registered with success…"
                    else
                        echo "ERROR: API key already registered but bouncer re-register attempt error!"
                    fi
                else
                    echo "ERROR: API key already registered but bouncer re-registered without success!"
                fi
            else
                echo "ERROR: Unrecoverable API key registration error!"
            fi
        fi
    fi
}

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

service_prepare ()
{
    fix_perms
    # Create bouncers dir & permissions if needed
    if [ ! -d "${CONFIGDIR}/bouncers" ]; then
        echo "Create initial run directory: ${CONFIGDIR}/bouncers"
        mkdir -m 0775 -p "${CONFIGDIR}/bouncers"
        chown sc-crowdsec:sc-crowdsec "${CONFIGDIR}/bouncers" -R
    fi

    # Create the config file on demand
    if [ ! -e "${CSFB_CUSTOMCONFIG}" ]; then
        echo "Create initial bouncer config file: ${CSFB_CUSTOMCONFIG}"
	    install -m 644 "${CSFB_INITIALCONFIG}" "${CSFB_CUSTOMCONFIG}"
    fi
    fix_perms
}

init_config() {
    fix_perms
    # Create the config file on demand
    if [ ! -e "${CSFB_CUSTOMCONFIG}" ]; then
        echo "Prepare initial config file: ${CSFB_CUSTOMCONFIG}"
        service_prepare
    fi

    # Prepare the config file if needed
    if [ -e "${CSFB_CUSTOMCONFIG}" ]; then
        echo "Modify initial config file: ${CSFB_CUSTOMCONFIG}"
        sed -i "s,^\(\s*pid_dir\s*:\s*\).*\$,\1${CROWDSEC_TMPDIR}/run," "${CSFB_CUSTOMCONFIG}"
        sed -i "s,^\(\s*log_dir\s*:\s*\).*\$,\1${CROWDSEC_TMPDIR}/log," "${CSFB_CUSTOMCONFIG}"
        sed -i "s,^\(\s*api_url\s*:\s*\).*\$,\1http://${LAPI_URL}:${LAPI_PORT}/," "${CSFB_CUSTOMCONFIG}"

        ## Gen&ConfigApiKey
        GenConfigApiKey
    fi

    # Modify the config file on demand
    if [ -e "${CSFB_CUSTOMCONFIG}" ]; then
	    ## CheckFirewall
	    IPTABLES="true"
	    which iptables > /dev/null
	    FW_BACKEND=""
	    if [[ $? != 0 ]]; then
	      echo "iptables is not present"
	      IPTABLES="false"
	    else
	      FW_BACKEND="iptables"
	      echo "iptables found"
	    fi

	    NFTABLES="true"
	    which nft > /dev/null
	    if [[ $? != 0 ]]; then
	      echo "nftables is not present"
	      NFTABLES="false"
	    else
	      FW_BACKEND="nftables"
	      echo "nftables found"
	    fi

	    if [ "${NFTABLES}" = "true" -a "${IPTABLES}" = "true" ]; then
	      echo "Found nftables(default) and iptables…"
	    fi

	    if [ "${FW_BACKEND}" = "iptables" ]; then
	      which ipset > /dev/null
	      if [[ $? != 0 ]]; then
	        echo "ipset not found, install it!"
	      fi
	    fi
	    BACKEND=${FW_BACKEND}

	    sed -i "s,^\(\s*mode\s*:\s*\).*\$,\1${BACKEND}," "${CSFB_CUSTOMCONFIG}"
    fi
    fix_perms
}

fix_runas_root ()
{
	sed -i "s/package/root/" "/var/packages/${PACKAGE}/conf/privilege"
}

service_postinst ()
{
#    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then    # Create data dir & permissions if needed
        service_prepare
#    fi
    fix_runas_root
}

service_postupgrade ()
{
    service_prepare
    fix_runas_root
}

load_ipset ()
{
    unload_ipset
    echo "INFO: loading ipset kernel modules from ${MODULES_DIR}"
    /sbin/insmod /lib/modules/nfnetlink.ko
	/sbin/insmod "${MODULES_DIR}/kernel/net/netfilter/ipset/ip_set.ko"
    /sbin/insmod "${MODULES_DIR}/kernel/net/netfilter/ipset/ip_set_hash_net.ko"
	/sbin/insmod "${MODULES_DIR}/kernel/net/netfilter/xt_set.ko"
	if [[ $(/sbin/lsmod | grep ip_set_hash_net) ]]; then
        echo "INFO: ipset kernel modules loaded…"
    else
        echo "ERROR: loading ipset kernel modules!"
    fi
}

unload_ipset ()
{
    echo "INFO: unloading ipset kernel modules…"
    /sbin/rmmod ip_set_hash_net --syslog
    /sbin/rmmod xt_set --syslog
    /sbin/rmmod ip_set --syslog
    /sbin/rmmod nfnetlink --syslog
	if [[ ! $(/sbin/lsmod | grep ip_set) ]]; then
        echo "INFO: ipset kernel modules unloaded…"
    else
        echo "ERROR: unloading ipset kernel modules!"
    fi
}

service_prestart ()
{
    init_config
    load_ipset
}

service_posttstop ()
{
    unload_ipset
}

