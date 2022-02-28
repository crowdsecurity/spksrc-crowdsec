# synology-libmnl-cross
#
# SPDX-License-Identifier: LGPLv2.1+
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
# Copyright (C) 2021-2022 CrowdSec <crowdsec@crowdsec.net>
#

PKG_NAME = libmnl
PKG_VERS = 1.0.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.netfilter.org/projects/libmnl/files
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

MAINTAINER = "CyberMind"
MAINTAINER_URL = "https://cybermind.fr"
HOMEPAGE = https://www.netfilter.org/projects/libmnl/
COMMENT  = libmnl is a minimalistic user-space library oriented to Netlink developers.
LICENSE  = LGPLv2.1+

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

