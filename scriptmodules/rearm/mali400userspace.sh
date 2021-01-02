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
rp_module_licence="GPL2 https://raw.githubusercontent.com/mripard/sunxi-mali/blob/master/LICENSE"
rp_module_section="rearm"
rp_module_flags="!all armv7-mali"

function depends_mali400userspace() {
    getDepends "${depends[@]}"
}

function sources_mali400userspace() {
    if [ ! -d "/opt/rearm/libmali" ]; then
        git clone https://github.com/rearmit/libmali "/opt/rearm/libmali"
    fi

    git --git-dir=/opt/rearm/libmali/.git pull
    cp -r "/opt/rearm/libmali/." "$md_build"
}

function build_mali400userspace() {
    md_ret_require+=("$md_build/lib/arm-linux-gnueabihf/libmali.so")
}

function install_mali400userspace() {
    cp -r "$md_build"/. /usr/local/
    ldconfig
}

function remove_mali400userspace() {
    rm -r /usr/local/include/
    rm -r /usr/local/lib/arm-linux-gnueabihf/
}