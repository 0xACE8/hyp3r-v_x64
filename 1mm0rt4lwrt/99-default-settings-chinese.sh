#!/bin/sh

# luci language
uci set luci.main.lang=zh_cn
uci commit luci

uci -q get system.@imm_init[0] > "/dev/null" || uci -q add system imm_init > "/dev/null"

if ! uci -q get system.@imm_init[0].system_chn > "/dev/null"; then
        uci -q batch <<-EOF
                set system.@system[0].hostname='HyperWrt'
                set system.@system[0].timezone="PST8PDT,M3.2.0,M11.1.0"
                set system.@system[0].zonename="America/Los Angeles"
                set system.ntp.use_dhcp='0'

                delete system.ntp.server
                add_list system.ntp.server="cn.ntp.org.cn"
                add_list system.ntp.server="edu.ntp.org.cn"
                add_list system.ntp.server="ntp.ntsc.ac.cn"
                add_list system.ntp.server="ntp.tuna.tsinghua.edu.cn"

                set system.@imm_init[0].system_chn="1"
                commit system
        EOF
fi

# argon
uci batch <<EOF
set argon.@global[0].primary='#1c78ff'
set argon.@global[0].dark_primary='#1c78ff'
set argon.@global[0].blur='10'
set argon.@global[0].blur_dark='10'
set argon.@global[0].transparency='0.5'
set argon.@global[0].transparency_dark='0.5'
set argon.@global[0].mode='normal'
set argon.@global[0].online_wallpaper='none'
EOF
uci commit argon

# fix distfeeds
sed -i "/ace8/d" /etc/opkg/distfeeds.conf
sed -i "/passwall_packages/d" /etc/opkg/distfeeds.conf
sed -i "/passwall/d" /etc/opkg/distfeeds.conf
sed -i "/passwall2/d" /etc/opkg/distfeeds.conf
sed -i "/mosdns/d" /etc/opkg/distfeeds.conf
sed -i "/netspeedtest/d" /etc/opkg/distfeeds.conf

# firewall
uci batch <<EOF
delete firewall.@defaults[0].syn_flood='0'
set firewall.@defaults[0].input='ACCEPT'
set firewall.@defaults[0].forward='ACCEPT'
set firewall.@defaults[0].fullcone6='1'
delete firewall.@zone[0].network
add_list firewall.@zone[0].network='lan'
add_list firewall.@zone[0].network='lan6'
add_list firewall.@zone[0].network='lan2'
add_list firewall.@zone[0].network='lan3'
EOF
uci commit firewall
/etc/init.d/firewall restart

# network config
uci batch <<EOF
delete network.lan.ip6assign
delete network.globals.ula_prefix
set network.globals.packet_steering='1'
set network.lan.gateway='192.168.177.1'
set network.lan.dns='127.0.0.1'
set network.lan6=interface
set network.lan6.proto='dhcpv6'
set network.lan6.device='@lan'
set network.lan6.reqaddress='try'
set network.lan6.reqprefix='auto'
set network.lan2=interface
set network.lan2.proto='static'
set network.lan2.device='br-lan'
set network.lan2.ipaddr='192.168.177.78'
set network.lan2.netmask='255.255.255.0'
set network.lan2.gateway='192.168.177.1'
set network.lan2.metric='40'
set network.lan2.dns='127.0.0.1'
set network.lan3=interface
set network.lan3.proto='static'
set network.lan3.device='br-lan'
set network.lan3.ipaddr='192.168.177.79'
set network.lan3.netmask='255.255.255.0'
set network.lan3.gateway='192.168.177.1'
set network.lan3.dns='127.0.0.1'
set network.lan3.metric='40'
EOF
uci commit network
/etc/init.d/network restart

# dnscrypt-proxy2 setting
sed -i 's/START=18/START=99/g' /etc/init.d/dnscrypt-proxy
#sed -i 's/127.0.0.53:53/127.0.0.1:5335/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/ipv6_servers = false/ipv6_servers = true/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/odoh_servers = false/odoh_servers = true/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/http3 = false/http3 = true/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/cache_size = 4096/cache_size = 8000/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/127.0.0.1:9050/127.0.0.1:1070/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/127.0.0.1:8888/127.0.0.1:1101/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i 's/# proxy/proxy/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
#sed -i 's/# http_proxy/http_proxy/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
#sed -i 's/# blocked_names_file/blocked_names_file/g' /etc/dnscrypt-proxy2/dnscrypt-proxy.toml

exit 0
