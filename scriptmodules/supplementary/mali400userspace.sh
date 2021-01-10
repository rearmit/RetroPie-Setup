#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="mali400userspace"
rp_module_desc="Mali400 Userspace drivers"
rp_module_licence="https://github.com/rockchip-linux/libmali/blob/master/END_USER_LICENCE_AGREEMENT.txt"
rp_module_section="driver"
rp_module_flags="!all armv7-mali"

function depends_mali400userspace() {
    local depends=(cmake) # linux-headers-current-sunxi
    getDepends "${depends[@]}"
}

function sources_mali400userspace() {
    gitPullOrClone "$md_build" https://github.com/rearmit/libmali
}

function build_mali400userspace() {
    cmake . "-DMALI_VARIANT=400" "-DCMAKE_INSTALL_LIBDIR=lib/arm-linux-gnueabihf"
}

function install_mali400userspace() {
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -P cmake_install.cmake
    ldconfig
}

function remove_mali400userspace() {
    rm -r /usr/local/include/
    rm -r /usr/local/lib/arm-linux-gnueabihf/
}
