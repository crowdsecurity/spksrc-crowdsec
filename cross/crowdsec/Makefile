# synology-crowdsec-cross
#
# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
# Copyright (C) 2021-2022 CrowdSec <crowdsec@crowdsec.net>
#

PKG_NAME = crowdsec
PKG_VERS = 1.3.0
PKG_REV = 1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://codeload.github.com/crowdsecurity/crowdsec/tar.gz/v$(PKG_VERS)?
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)
#EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

PATCHES_LEVEL = 1

BUILD_DEPENDS = native/go

HOMEPAGE = "https://www.crowdsec.net"
LICENSE = "MIT"

DISTRIBUTOR = "CrowdSec"
DISTRIBUTOR_URL = "https://www.crowdsec.net"

MAINTAINER = "CyberMind"
MAINTAINER_URL = "https://cybermind.fr"

COMMENT = CrowdSec - the open-source and participative IPS able to analyze visitor behavior & provide an adapted response to all kinds of attacks. It also leverages the crowd power to generate a global CTI database to protect the user network.

COMPILE_TARGET = crowdsec_compile
INSTALL_TARGET = crowdsec_install

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/cmd/*/
CGO_ENABLED = 1
##GO111MODULE = on

include ../../mk/spksrc.cross-go.mk

SYSTEM = synology
DEFAULT_CONFIGPATH="/var/packages/crowdsec/etc"
DEFAULT_DATAPATH="${DEFAULT_CONFIGPATH}/data"

ENV += BUILD_VERSION=v${PKG_VERS}
ENV += BUILD_TAG=$(SYSTEM)-$(PKG_VERS)-$(PKG_REV)
ENV += BUILD_TIMESTAMP:=$(shell date +%F"_"%T)
ENV += DEFAULT_CONFIGDIR=${DEFAULT_CONFIGPATH}
ENV += DEFAULT_DATADIR=${DEFAULT_DATAPATH}

crowdsec_compile:
	$(RUN) $(MAKE) build

crowdsec_install:
	@$(MSG) "Copying binary files"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/usr/sbin
	install -m 551 $(GO_SRC_DIR)/cmd/crowdsec/crowdsec $(STAGING_INSTALL_PREFIX)/usr/sbin/crowdsec
	install -m 551 $(GO_SRC_DIR)/cmd/crowdsec-cli/cscli $(STAGING_INSTALL_PREFIX)/usr/sbin/cscli
	@$(MSG) "Copying config files"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec
	install -m 644 $(GO_SRC_DIR)/config/config.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/config.yaml
	install -m 644 $(GO_SRC_DIR)/config/dev.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/dev.yaml
	install -m 644 $(GO_SRC_DIR)/config/user.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/user.yaml
	install -m 644 $(GO_SRC_DIR)/config/acquis.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/acquis.yaml
	install -m 644 $(GO_SRC_DIR)/config/profiles.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/profiles.yaml
	install -m 644 $(GO_SRC_DIR)/config/simulation.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/simulation.yaml
	install -m 644 $(GO_SRC_DIR)/config/local_api_credentials.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/local_api_credentials.yaml
	install -m 644 $(GO_SRC_DIR)/config/online_api_credentials.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/online_api_credentials.yaml
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/scenarios
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/postoverflows
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/collections
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/patterns
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/hub
	install -m 775 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/bouncers
	cp -f $(GO_SRC_DIR)/config/patterns/* $(STAGING_INSTALL_PREFIX)/etc/crowdsec/patterns/
	@$(MSG) "Copying plugins files"
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/usr/lib/crowdsec/plugins
	install -m 551 $(GO_SRC_DIR)/plugins/notifications/slack/notification-slack $(STAGING_INSTALL_PREFIX)/usr/lib/crowdsec/plugins/
	install -m 551 $(GO_SRC_DIR)/plugins/notifications/http/notification-http $(STAGING_INSTALL_PREFIX)/usr/lib/crowdsec/plugins/
	install -m 551 $(GO_SRC_DIR)/plugins/notifications/splunk/notification-splunk $(STAGING_INSTALL_PREFIX)/usr/lib/crowdsec/plugins/
	install -m 551 $(GO_SRC_DIR)/plugins/notifications/email/notification-email $(STAGING_INSTALL_PREFIX)/usr/lib/crowdsec/plugins/
	install -m 775 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/notifications
	install -m 664 $(GO_SRC_DIR)/plugins/notifications/slack/slack.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/notifications/slack.yaml
	install -m 664 $(GO_SRC_DIR)/plugins/notifications/http/http.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/notifications/http.yaml
	install -m 664 $(GO_SRC_DIR)/plugins/notifications/splunk/splunk.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/notifications/splunk.yaml
	install -m 664 $(GO_SRC_DIR)/plugins/notifications/email/email.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/notifications/email.yaml
	@$(MSG) "Creating directories"
	install -m 775 -d $(STAGING_INSTALL_PREFIX)/share/crowdsec
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/bouncers
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/data
