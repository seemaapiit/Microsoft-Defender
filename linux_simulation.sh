#!/bin/bash

# PERSISTENCE
## https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1136.001/T1136.001.md#atomic-test-5---create-a-new-user-in-linux-with-root-uid-and-gid
useradd -e 1970-01-01 -g 0 -M -d /root -s '/bin/bash' butter
if [ $(cat /etc/os-release | grep -i 'Name="ubuntu"') ]; then echo "butter:BetterWithButter" | chpasswd; else echo "BetterWithButter" | passwd --stdin butter; fi;
userdel butter

# DISCOVERY
## https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1217/T1217.md#atomic-test-1---list-mozilla-firefox-bookmark-database-files-on-linux
find / -path "*.mozilla/firefox/*/places.sqlite" 2>/dev/null -exec echo {} >> /tmp/T1217-Firefox.txt
cat /tmp/T1217-Firefox.txt 2>/dev/null
rm -f /tmp/T1217-Firefox.txt 2>/dev/null

## https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1083/T1083.md#atomic-test-4---nix-file-and-directory-discovery-2
cd $HOME && find . -print | sed -e 's;[^/]*/;|__;g;s;__|; |;g'
find . -type f -iname *.pdf

## https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1082/T1082.md#atomic-test-3---list-os-information
uname -a >> /tmp/T1082.txt
if [ -f /etc/lsb-release ]; then cat /etc/lsb-release >> /tmp/T1082.txt; fi;
if [ -f /etc/redhat-release ]; then cat /etc/redhat-release >> /tmp/T1082.txt; fi;      
if [ -f /etc/issue ]; then cat /etc/issue >> /tmp/T1082.txt; fi;
uptime >> /tmp/T1082.txt
cat /tmp/T1082.txt 2>/dev/null

# DEFENSE EVASION
## https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1027/T1027.md#atomic-test-1---decode-base64-data-into-script
sh -c "echo ZWNobyBIZWxsbyBmcm9tIHRoZSBBdG9taWMgUmVkIFRlYW0= > /tmp/encoded.dat"
cat /tmp/encoded.dat | base64 -d > /tmp/art.sh
chmod +x /tmp/art.sh
/tmp/art.sh