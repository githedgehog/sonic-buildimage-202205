# docker image for orchagent

DOCKER_ORCHAGENT_STEM = docker-orchagent
DOCKER_ORCHAGENT = $(DOCKER_ORCHAGENT_STEM).gz
DOCKER_ORCHAGENT_DBG = $(DOCKER_ORCHAGENT_STEM)-$(DBG_IMAGE_MARK).gz

$(DOCKER_ORCHAGENT)_DEPENDS += $(SWSS)

$(DOCKER_ORCHAGENT)_DBG_DEPENDS = $($(DOCKER_CONFIG_ENGINE_BUSTER)_DBG_DEPENDS)
$(DOCKER_ORCHAGENT)_DBG_DEPENDS +=   $(SWSS_DBG) \
                                $(LIBSWSSCOMMON_DBG) \
                                $(LIBSAIREDIS_DBG)
$(DOCKER_ORCHAGENT)_PYTHON_WHEELS += $(SCAPY)

$(DOCKER_ORCHAGENT)_DBG_IMAGE_PACKAGES = $($(DOCKER_CONFIG_ENGINE_BUSTER)_DBG_IMAGE_PACKAGES)

$(DOCKER_ORCHAGENT)_PATH = $(DOCKERS_PATH)/$(DOCKER_ORCHAGENT_STEM)

$(DOCKER_ORCHAGENT)_LOAD_DOCKERS += $(DOCKER_CONFIG_ENGINE_BUSTER)

$(DOCKER_ORCHAGENT)_VERSION = 1.0.0
$(DOCKER_ORCHAGENT)_PACKAGE_NAME = swss
$(DOCKER_ORCHAGENT)_WARM_SHUTDOWN_BEFORE = syncd
$(DOCKER_ORCHAGENT)_FAST_SHUTDOWN_BEFORE = syncd

SONIC_DOCKER_IMAGES += $(DOCKER_ORCHAGENT)
ifeq ($(INCLUDE_SWSS), y)
SONIC_INSTALL_DOCKER_IMAGES += $(DOCKER_ORCHAGENT)
endif

SONIC_DOCKER_DBG_IMAGES += $(DOCKER_ORCHAGENT_DBG)
ifeq ($(INCLUDE_SWSS), y)
SONIC_INSTALL_DOCKER_DBG_IMAGES += $(DOCKER_ORCHAGENT_DBG)
endif

$(DOCKER_ORCHAGENT)_CONTAINER_NAME = swss
$(DOCKER_ORCHAGENT)_RUN_OPT += --privileged -t
$(DOCKER_ORCHAGENT)_RUN_OPT += -v /etc/network/interfaces:/etc/network/interfaces:ro
$(DOCKER_ORCHAGENT)_RUN_OPT += -v /etc/network/interfaces.d/:/etc/network/interfaces.d/:ro
$(DOCKER_ORCHAGENT)_RUN_OPT += -v /host/machine.conf:/host/machine.conf:ro
$(DOCKER_ORCHAGENT)_RUN_OPT += -v /etc/sonic:/etc/sonic:ro
$(DOCKER_ORCHAGENT)_RUN_OPT += -v /var/log/swss:/var/log/swss:rw

$(DOCKER_ORCHAGENT)_BASE_IMAGE_FILES += swssloglevel:/usr/bin/swssloglevel
$(DOCKER_ORCHAGENT)_FILES += $(ARP_UPDATE_SCRIPT) $(ARP_UPDATE_VARS_TEMPLATE) $(SUPERVISOR_PROC_EXIT_LISTENER_SCRIPT)

SONIC_BUSTER_DOCKERS += $(DOCKER_ORCHAGENT)
SONIC_BUSTER_DBG_DOCKERS += $(DOCKER_ORCHAGENT_DBG)
