# Make wrapper for avr gcc
# Copyleft 2018 by Noah Huetter <noahhuetter@gmail.com>
# 
# Based on https://github.com/nachoparker/mmake by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# ##########################################################################################
# Make wrapper with GCC 6, colorgcc and ccache
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage:
#
#   It is recommended to use this alias
#
#     alias mmake='docker run --rm -v "$(pwd):/src" -t ownyourbits/mmake'
#
#   Then, use it just as you would use 'make'
#
# Note: a '.ccache' directory will be generated in the directory of execution
#
# Note: you can leave the container running for faster execution. Use these aliases
#
#     alias runmake='docker run --rm -d -v "$(pwd):/src" --entrypoint /bg.sh -t --name mmake ownyourbits/mmake'
#     alias mmake='docker exec -t mmake /run.sh'
#
# Details at ownyourbits.com
# ##########################################################################################

FROM ownyourbits/minidebian

LABEL description="Make wrapper avr gcc, colorgcc and ccache"
MAINTAINER Noah Huetter <noahhuetter@gmail.com>

# Install toolchain 
# Source: https://github.com/KaDock/avr-toolchain
RUN DEBIAN_FRONTEND=noninteractive apt-get --quiet --yes update \
    && DEBIAN_FRONTEND=noninteractive apt-get --quiet --yes install \
        make ccache colorgcc \
        avr-libc \
        avra \
        avrdude \
        avrp \
        avrprog \
        build-essential \
        binutils-avr \
        python \
        gcc-avr \
        gdb-avr \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists

# bc to print compilation time
RUN sudo apt-get update; \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends bc; \
    sudo apt-get autoremove -y; sudo apt-get clean; sudo rm /var/lib/apt/lists/* -r; sudo rm -rf /usr/share/man/*

# Set colorgcc and ccache
COPY colorgccrc /etc/colorgcc/colorgccrc

# RUN mkdir  /usr/lib/colorgcc; \
#     ln -s /usr/bin/colorgcc /usr/lib/colorgcc/c++; \
#     ln -s /usr/bin/colorgcc /usr/lib/colorgcc/cc ; \
#     ln -s /usr/bin/colorgcc /usr/lib/colorgcc/gcc; \
#     ln -s /usr/bin/colorgcc /usr/lib/colorgcc/g++; 
RUN mkdir  /usr/lib/colorgcc; \
    ln -s /usr/bin/colorgcc /usr/lib/colorgcc/avr-gcc; 

# Builder user
RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends adduser; \
    adduser builder --disabled-password --gecos ""; \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
    sed -i "s|^#force_color_prompt=.*|force_color_prompt=yes|" /home/builder/.bashrc; \
    apt-get purge -y adduser passwd; \
    apt-get autoremove -y; apt-get clean; rm /var/lib/apt/lists/* -r; rm -rf /usr/share/man/*

RUN echo 'export PATH="/usr/lib/colorgcc/:$PATH"' >> /home/builder/.bashrc; \
    echo 'export CCACHE_DIR=/src/.ccache'         >> /home/builder/.bashrc; \
    echo 'export TERM="xterm"'                    >> /home/builder/.bashrc; 

COPY bg.sh run.sh /
RUN chmod 777 /bg.sh && chmod 777 /run.sh

USER builder

# Run
ENTRYPOINT ["/run.sh"]


# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA

