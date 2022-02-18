# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
#

SRCNAME = cs-firewall-bouncer
PKG_NAME = crowdsec-firewall-bouncer
PKG_VERS = 0.0.22
PKG_REV = 1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://codeload.github.com/crowdsecurity/cs-firewall-bouncer/tar.gz/v$(PKG_VERS)?
#PKG_DIST_FILE = $(SRCNAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)
#EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

MAINTAINER = Gerald Kerma gandalf@gk2.net
HOMEPAGE = https://crowdsec.net
COMMENT  = crowdsec-firewall-bouncer will fetch new and old decisions from a CrowdSec API to add them in a blocklist used by supported firewalls.
LICENSE  = MIT

COMPILE_TARGET = crowdsec-firewall-bouncer_compile
INSTALL_TARGET = crowdsec-firewall-bouncer_install

GO_SRC_DIR = $(WORK_DIR)/$(SRCNAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk

SYSTEM = synology

ENV += BUILD_VERSION=v${PKG_VERS}
ENV += BUILD_TAG=$(SYSTEM)-$(PKG_VERS)-$(PKG_REV)
ENV += BUILD_TIMESTAMP:=$(shell date +%F"_"%T)

crowdsec-firewall-bouncer_compile:
	@$(MSG) "Compile"
	cd $(GO_SRC_DIR) && env $(ENV) $(MAKE) build

crowdsec-firewall-bouncer_install:
	@$(MSG) "Copying binary files"
	install -m 775 -d $(STAGING_INSTALL_PREFIX)/usr/sbin
	install -m 551 $(GO_SRC_DIR)/crowdsec-firewall-bouncer $(STAGING_INSTALL_PREFIX)/usr/sbin/crowdsec-firewall-bouncer
	@$(MSG) "Copying config files"
	install -m 775 -d $(STAGING_INSTALL_PREFIX)/etc/crowdsec/bouncers
	install -m 664 $(GO_SRC_DIR)/config/crowdsec-firewall-bouncer.yaml $(STAGING_INSTALL_PREFIX)/etc/crowdsec/bouncers/crowdsec-firewall-bouncer.yaml

