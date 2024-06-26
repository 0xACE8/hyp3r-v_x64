#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: 0xACE7
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.177.70/g' package/base-files/files/bin/config_generate

# Set password to PASSWORD
sed -i 's/root:::0:99999:7:::/root:$1$4xKZB45Q$w0CPT5M6vBWbYNmSWuxfU.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Change language=auto to zh_cn
# sed -i 's/lang="auto"/lang="zh_cn"/g' package/emortal/default-settings/files/99-default-settings

#. Modify Hostname
sed -i "/uci commit system/i\uci set system.@system[0].hostname='LedeWrt'" package/lean/default-settings/files/zzz-default-settings

#. Modify builder
sed -i "s/OpenWrt /LEDE OpenWrt build $(TZ=UTC-3 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

#. Change luci list name
#sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' feeds/luci/applications/luci-app-turboacc/po/zh-cn/turboacc.po
#sed -i 's/revert_dns()/trever_dns()/' feeds/luci/applications/luci-app-turboacc/root/etc/init.d/turboacc
#sed -i 's/revert_dns//' feeds/luci/applications/luci-app-turboacc/root/etc/init.d/turboacc
#sed -i 's/trever_dns()/revert_dns()/' feeds/luci/applications/luci-app-turboacc/root/etc/init.d/turboacc

# Change ash to bash
sed -i 's/ash/bash/g' package/base-files/files/etc/passwd

# Modify Ntp server
#sed -i 's/ntp.tencent.com/ntp.ntsc.ac.cn/g' package/emortal/default-settings/files/99-default-settings-chinese
#sed -i 's/ntp1.aliyun.com/cn.ntp.org.cn/g' package/emortal/default-settings/files/99-default-settings-chinese
#sed -i 's/ntp.tencent.com/edu.ntp.org.cn/g' package/emortal/default-settings/files/99-default-settings-chinese
#sed -i 's/ntp.tencent.com/ntp.tuna.tsinghua.edu.cn/g' package/emortal/default-settings/files/99-default-settings-chinese

# luci theme argon update
sed -i 's/"Argone 主题设置"/"主题设置"/g' feeds/ace8/luci-app-argone-config/po/zh-cn/argone-config.po
#rm -rf feeds/ace8/luci-theme-argone/htdocs/luci-static/argone/img/bg1.jpg
#wget --no-check-certificate -O feeds/ace8/luci-theme-argone/htdocs/luci-static/argone/img/bg1.jpg "https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64_l3d3/main/bg1.jpg"
sed -i 's/5e72e4/1c78ff/g' feeds/ace8/luci-theme-argone/htdocs/luci-static/argone/css/cascade.css
sed -i 's/5e72e4/1c78ff/g' feeds/ace8/luci-theme-argone/htdocs/luci-static/argone/css/dark.css
sed -i 's/483d8b/1c78ff/g' feeds/ace8/luci-theme-argone/htdocs/luci-static/argone/css/cascade.css
sed -i 's/483d8b/1c78ff/g' feeds/ace8/luci-theme-argone/htdocs/luci-static/argone/css/dark.css

# ttyd menu name
sed -i '65s/^#//g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
sed -i 's/"终端"/"TTYD 终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po

# dnscrypt-proxy start
sed -i 's/START=18/START=99/g' feeds/packages/net/dnscrypt-proxy2/files/dnscrypt-proxy.init

# DHCP
#mkdir -p package/base-files/files/etc/dnsmasq.d
#wget --no-check-certificate -O package/base-files/files/etc/dnsmasq.d/accelerated-domains.china.conf "https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf"

# Boost UDP
echo '# optimize udp' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.rmem_max=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.rmem_default=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.wmem_max=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.wmem_default=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.netdev_max_backlog=2048' >>package/base-files/files/etc/sysctl.d/10-default.conf

# upgrade 99-default-settings-chinese.sh
# rm -rf package/emortal/default-settings/files/99-default-settings-chinese.sh
# wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64_u3f1/main/99-default-settings-chinese.sh -O package/emortal/default-settings/files/99-default-settings-chinese.sh

# add init settings
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/l3d3/99-init-settings -O package/base-files/files/etc/uci-defaults/99-init-settings
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/l3d3/30-sysinfo.sh -O feeds/packages/utils/bash/files/etc/profile.d/30-sysinfo.sh

# Change to my banner
sudo rm package/base-files/files/etc/banner
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/l3d3/banner -O package/base-files/files/etc/banner

echo "diy-part2.sh is done."
