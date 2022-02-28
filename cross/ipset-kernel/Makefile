# synology-ipset-kernel-cross
#
# SPDX-License-Identifier: LGPLv2.1+
#
# Copyright (C) 2021-2022 Gerald Kerma <gandalf@gk2.net>
# Copyright (C) 2021-2022 CrowdSec <crowdsec@crowdsec.net>
#

SRCNAME = ipset
PKG_NAME = ipset-kernel
PKG_VERS = 7.15
PKG_REV = 2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(SRCNAME)-$(PKG_VERS)
PKG_DIST_SITE = https://ipset.netfilter.org
PKG_DIST_FILE = $(SRCNAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(SRCNAME)-$(PKG_VERS)
#EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libmnl 

MAINTAINER = "CyberMind"
MAINTAINER_URL = "https://cybermind.fr"
HOMEPAGE = https:/www.netfilter.org/projects/ipset/index.html
COMMENT  = ipset --- administration tool for IP sets.
LICENSE  = MIT

ENV += CONFIG_IP_SET_MAX=256

REQUIRE_KERNEL = 1
# xtset core
REQUIRE_KERNEL_MODULE  = CONFIG_NETFILTER_XT_SET:net/netfilter:xt_set
# ipset max number of sets
## FIXME
##REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_MAX=256
# ipset core
REQUIRE_KERNEL_MODULE += CONFIG_IP_SET:net/netfilter/ipset:ip_set
# bitmap types
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_BITMAP_IP:net/netfilter/ipset:ip_set_bitmap_ip
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_BITMAP_IPMAC:net/netfilter/ipset:ip_set_bitmap_ipmac
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_BITMAP_PORT:net/netfilter/ipset:ip_set_bitmap_port
# hash types
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_IP:net/netfilter/ipset:ip_set_hash_ip
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_IPMARK:net/netfilter/ipset:ip_set_hash_ipmark
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_IPPORT:net/netfilter/ipset:ip_set_hash_ipport
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_IPPORTIP:net/netfilter/ipset:ip_set_hash_ipportip
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_IPPORTNET:net/netfilter/ipset:ip_set_hash_ipportnet
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_MAC:net/netfilter/ipset:ip_set_hash_mac
REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_NET:net/netfilter/ipset:ip_set_hash_net
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_NETPORT:net/netfilter/ipset:ip_set_hash_netport
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_NETIFACE:net/netfilter/ipset:ip_set_hash_netiface
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_NETNET:net/netfilter/ipset:ip_set_hash_netnet
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_HASH_NETPORTNET:net/netfilter/ipset:ip_set_hash_netportnet
# list types
## FIXME : REQUIRE_KERNEL_MODULE += CONFIG_IP_SET_LIST_SET:net/netfilter/ipset:ip_set_list_set

#COMPILE_TARGET = ipset-kernel_compile
#INSTALL_TARGET = ipset-kernel_install
STRIP_TARGET      = nop
POST_STRIP_TARGET = nop

KO_DIR = $(INSTALL_DIR)$(INSTALL_PREFIX)/lib/modules/$(TC_KERNEL)/net/netfilter
SRC_DIR = $(WORK_DIR)/$(SRCNAME)-$(PKG_VERS)
LINUX_DIR = $(KERNEL_ROOT)

MOD_DIR = /lib/modules

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-kbuild=$(KERNEL_ROOT)

CFLAGS += -I"$(LINUX_DIR)/include"

#TARGET_LDFLAGS += -Wl,--gc-sections,--as-needed

include ../../mk/spksrc.cross-cc.mk

PLIST_TRANSFORM = sed -e 's%@TC_KERNEL@%$(TC_KERNEL)%'

.PHONY: ipset-kernel_compile
ipset-kernel_compile:
	$(RUN) ARCH=$(TC_ARCH) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) $(MAKE) -C $(SRC_DIR) --include-dir=$(KERNEL_ROOT) modules
###	cd $(SRC_DIR) && env $(ENV) ARCH=$(TC_ARCH) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) KSRC=$(LINUX_DIR) $(MAKE) -C $(SRC_DIR) KERNEL_DIR=$(LINUX_DIR) build modules

.PHONY: ipset-kernel_install
ipset-kernel_install:
	$(RUN) mkdir -p $(KO_DIR)
# xtset core
	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/xt_set.ko $(KO_DIR)
	$(RUN) mkdir -p $(KO_DIR)/ipset
# ipset core
	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set.ko $(KO_DIR)/ipset
# bitmap types
## FIXME : 	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_bitmap_ip.ko $(KO_DIR)/ipset
## FIXME : 	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_bitmap_ipmac.ko $(KO_DIR)/ipset
## FIXME : 	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_bitmap_port.ko $(KO_DIR)/ipset
# hash types
## FIXME : 	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_ip.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_ipmark.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_ipport.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_ipportip.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_ipportnet.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_mac.ko $(KO_DIR)/ipset
	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_net.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_netport.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_netiface.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_netnet.ko $(KO_DIR)/ipset
## FIXME :	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_hash_netportnet.ko $(KO_DIR)/ipset
# list types
## FIXME : 	install -p -m 644 $(WORK_DIR)/linux/net/netfilter/ipset/ip_set_list_set.ko $(KO_DIR)/ipset

