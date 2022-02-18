# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
# Copyright (C) 2021-2022 CrowdSec <crowdsec@crowdsec.net>
#

SPK_NAME = crowdsec-firewall-bouncer
SPK_VERS = 0.0.22
SPK_REV = 4
SPK_ICON = src/$(SPK_NAME).png
CHANGELOG = "1. Initial package for DSM7\n2. add ipset tool\n3. add ipset kernel modules\n3. add ipset tool\n3. DSM6 compatibility mode added\n4. First relase"

DEPENDS  = cross/$(SPK_NAME)
##DEPENDS += cross/ipset
DEPENDS += cross/ipset-kernel

##SPK_DEPENDS = "crowdsec"
OPTIONAL_DEPENDS = "crowdsec"

MAINTAINER = "Gerald Kerma <gandalf@gk2.net>"
DESCRIPTION = crowdsec-firewall-bouncer will fetch new and old decisions from a CrowdSec API to add them in a blocklist used by supported firewalls.
RELOAD_UI = yes
STARTABLE = yes

DISPLAY_NAME = CrowdSec-Firewall-Bouncer
HOMEPAGE = https://www.crowdsec.net
LICENSE = MIT

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
    CONF_DIR = src/conf_7
    SPK_GROUP = sc-crowdsec
    SPK_USER = crowdsec
    SYSTEM_GROUP = system
    SERVICE_USER = auto
else ifeq ($(call version_ge, ${TCVERSION}, 6.0),1)
    CONF_DIR = src/conf_6
    SPK_GROUP = sc-crowdsec
    SPK_USER = crowdsec
    SYSTEM_GROUP = system
    SERVICE_USER = root
endif

SERVICE_SETUP = src/service-setup.sh

PRE_STRIP_TARGET	= nop
STRIP_TARGET		= nop
POST_STRIP_TARGET	= nop

SPK_USR_LOCAL_LINKS  = bin:usr/sbin/crowdsec-firewall-bouncer
SPK_USR_LOCAL_LINKS += lib:lib/libmnl.so
SPK_USR_LOCAL_LINKS += lib:lib/libmnl.so.0
SPK_USR_LOCAL_LINKS += lib:lib/libmnl.so.0.2.0
SPK_USR_LOCAL_LINKS += bin:sbin/ipset
SPK_USR_LOCAL_LINKS += bin:sbin/ipset-translate
SPK_USR_LOCAL_LINKS += lib:lib/modules

SPK_COMMANDS  = usr/sbin/crowdsec-firewall-bouncer
SPK_COMMANDS += sbin/ipset

include ../../mk/spksrc.spk.mk
