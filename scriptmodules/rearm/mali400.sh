#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mali400"
rp_module_desc="Mali400"
rp_module_licence="GPL2 https://raw.githubusercontent.com/mripard/sunxi-mali/blob/master/LICENSE"
rp_module_section="rearm"
rp_module_flags="!all armv7-mali"

function depends_mali400() {
    getDepends "${depends[@]}"
}

function sources_mali400() {
	gitPullOrClone "$md_build" https://github.com/rearmit/sunxi-mali
}

function build_mali400() {
    export KDIR=/lib/modules/`uname -r`/build
    export CROSS_COMPILE=
    export INSTALL_MOD_PATH=
    ./build.sh -r r9p0 -c
    ./build.sh -r r9p0 -b
    md_ret_require+=("$md_build/mali.ko")
}

function install_mali400() {
    ./build.sh -r r9p0 -i
    depmod -a
    echo mali > /etc/modules-load.d/mali.conf
    echo KERNEL==\"mali\", MODE=\"0660\", GROUP=\"video\" > /etc/udev/rules.d/50-mali.rules
    grep -qxF 'blacklist lima' /etc/modprobe.d/blacklist-lima.conf || echo 'blacklist lima' >> /etc/modprobe.d/blacklist-lima.conf
    modprobe -r lima
    modprobe mali
    chmod 0660 /dev/mali
    sed -i 's/setenv disp_mem_reserves \"off\"/setenv disp_mem_reserves \"on\"/g' /boot/boot.cmd
    mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr
    grep -qxF 'extraargs="drm_kms_helper.drm_fbdev_overalloc=300"' /boot/armbianEnv.txt || echo 'extraargs="drm_kms_helper.drm_fbdev_overalloc=300"' >> /boot/armbianEnv.txt
}

function remove_mali400() {
    rm /etc/modules-load.d/mali.conf
    rm /etc/udev/rules.d/50-mali.rules
    rm /lib/modules/`uname -r`/extra/mali.ko
    rm /etc/modprobe.d/blacklist-lima.conf
    depmod -a
}
