# SPDX-License-Identifier: MIT
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
#

SRCNAME = ipset
PKG_NAME = $(SRCNAME)
PKG_VERS = 7.15
PKG_REV = 1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(SRCNAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ipset.netfilter.org
PKG_DIR =  $(SRCNAME)-$(PKG_VERS)

DEPENDS = cross/libmnl

MAINTAINER = Gerald Kerma gandalf@gk2.net
HOMEPAGE = https://www.netfilter.org/projects/ipset/index.html
COMMENT  = ipset --- administration tool for IP sets.
LICENSE  = MIT

GNU_CONFIGURE = 1

REQUIRE_KERNEL = 1

##CONFIGURE_ARGS += --host=$(TC_TARGET)
CONFIGURE_ARGS += --with-kbuild=$(KERNEL_ROOT)
CONFIGURE_ARGS += --with-ksource=$(KERNEL_ROOT)
##CONFIGURE_ARGS += --includedir=$(KERNEL_ROOT)/arch/$(ARCH)/include
CONFIGURE_ARGS += --enable-settype-modules=no
CONFIGURE_ARGS += --with-gnu-ld=yes

include ../../mk/spksrc.cross-cc.mk


