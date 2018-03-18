#!/usr/bin/env bash
. ./functions.sh

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    log "Installing Virtualbox guest additions"
    VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
    mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt >/dev/null 2>&1
    sh /mnt/VBoxLinuxAdditions.run >/dev/null 2>&1
    umount /mnt >/dev/null 2>&1
    rm /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/${SSH_USER}/.vbox_version
    if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi
fi
if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    function install_open_vm_tools {
        log "Installing Open VM Tools"
        apt-get install -y open-vm-tools >/dev/null 2>&1
        apt-get install -y open-vm-tools-desktop >/dev/null 2>&1
        # Add /mnt/hgfs so the mount works automatically with Vagrant
        mkdir /mnt/hgfs
    }
    function install_vmware_tools {
        log "Installing VMware Tools"
        cd /tmp
        mkdir -p /mnt/cdrom
        mount -o loop /home/${SSH_USERNAME}/linux.iso /mnt/cdrom
        VMWARE_TOOLS_PATH=$(ls /mnt/cdrom/VMwareTools-*.tar.gz)
        VMWARE_TOOLS_VERSION=$(echo "${VMWARE_TOOLS_PATH}" | cut -f2 -d'-')
        VMWARE_TOOLS_BUILD=$(echo "${VMWARE_TOOLS_PATH}" | cut -f3 -d'-')
        VMWARE_TOOLS_BUILD=$(basename ${VMWARE_TOOLS_BUILD} .tar.gz)
        echo "==> VMware Tools Path: ${VMWARE_TOOLS_PATH}"
        echo "==> VMWare Tools Version: ${VMWARE_TOOLS_VERSION}"
        echo "==> VMware Tools Build: ${VMWARE_TOOLS_BUILD}"
        tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
        VMWARE_TOOLS_MAJOR_VERSION=$(echo ${VMWARE_TOOLS_VERSION} | cut -d '.' -f 1)
        if [ "${VMWARE_TOOLS_MAJOR_VERSION}" -lt "10" ]; then
            /tmp/vmware-tools-distrib/vmware-install.pl -d
        else
            /tmp/vmware-tools-distrib/vmware-install.pl -f
        fi
        rm /home/${SSH_USERNAME}/linux.iso
        umount /mnt/cdrom
        rmdir /mnt/cdrom
        rm -rf /tmp/VMwareTools-*
        VMWARE_TOOLBOX_CMD_VERSION=$(vmware-toolbox-cmd -v)
        log "Installed VMware Tools ${VMWARE_TOOLBOX_CMD_VERSION}"
    }
    if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
        KERNEL_VERSION=$(uname -r | cut -d. -f1-2)
        echo "==> Kernel version ${KERNEL_VERSION}"
        MAJOR_VERSION=$(echo ${KERNEL_VERSION} | cut -d '.' -f1)
        MINOR_VERSION=$(echo ${KERNEL_VERSION} | cut -d '.' -f2)
        if [ "${MAJOR_VERSION}" -ge "4" ] && [ "${MINOR_VERSION}" -ge "1" ]; then
            # open-vm-tools supports shared folders on kernel 4.1 or greater
            . /etc/lsb-release
            if [[ $DISTRIB_RELEASE == 14.04 ]]; then
                install_vmware_tools
                # Ensure that VMWare Tools recompiles kernel modules
                echo "answer AUTO_KMODS_ENABLED yes" >> /etc/vmware-tools/locations
            else 
                install_open_vm_tools
            fi
        else
            install_vmware_tools
        fi 
    fi
fi