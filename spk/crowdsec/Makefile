# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
# Copyright (C) 2021-2022 CrowdSec <crowdsec@crowdsec.net>
#

SPK_NAME = crowdsec
SPK_VERS = 1.3.0
SPK_REV = 4
SPK_ICON = src/$(SPK_NAME).png

DISPLAY_NAME = CrowdSec
DESCRIPTION  = "CrowdSec - the open-source and participative IPS able to analyze visitor behavior & provide an adapted response to all kinds of attacks. It also leverages the crowd power to generate a global CTI database to protect the user network."
CHANGELOG = "1. Initial package for DSM7\n2. add ipset tool\n2. DSM6 compatibility mode added\n3. First relase\n4. Fix Copyright"

THIRDPARTY = "yes"
HOMEPAGE = "https://www.crowdsec.net"
LICENSE = "MIT"

DISTRIBUTOR = "CrowdSec"
DISTRIBUTOR_URL = "https://www.crowdsec.net"

MAINTAINER = "CyberMind"
MAINTAINER_URL = "https://cybermind.fr"

RELOAD_UI = yes
STARTABLE = yes

DEPENDS = cross/$(SPK_NAME)

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

SPK_USR_LOCAL_LINKS  = bin:usr/sbin/crowdsec
SPK_USR_LOCAL_LINKS += bin:usr/sbin/cscli
SPK_USR_LOCAL_LINKS += etc:etc/crowdsec
SPK_USR_LOCAL_LINKS += share:share/crowdsec
SPK_USR_LOCAL_LINKS += lib:usr/lib/crowdsec

SPK_COMMANDS  = usr/sbin/crowdsec
SPK_COMMANDS += usr/sbin/cscli


POST_STRIP_TARGET = crowdsec-custom_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: crowdsec-custom_extra_install
crowdsec-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/share/crowdsec
	install -m 755 -d $(STAGING_DIR)/etc/crowdsec/bouncers
	install -m 755 -d $(STAGING_DIR)/etc/crowdsec/data
	install -m 755 -d $(STAGING_DIR)/etc/crowdsec/acquis.d
	install -m 644 src/config/synology.yaml $(STAGING_DIR)/etc/crowdsec/acquis.d/synology.yaml
