#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: 0xACE7
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.177.77/g' package/base-files/files/bin/config_generate

# Change language=auto to zh_cn
sed -i 's/lang="auto"/lang="zh_cn"/g' package/emortal/default-settings/files/99-default-settings

# Change ash to bash
sed -i 's/ash/bash/g' package/base-files/files/etc/passwd

# luci theme argon update
sed -i 's/"Argon 主题设置"/"主题设置"/g' feeds/ace8/luci-app-argon-config/po/zh_Hans/argon-config.po
rm -rf feeds/ace8/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
wget --no-check-certificate -O feeds/ace8/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg "https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/1mm0rt4lwrt/bg1.jpg"

# ttyd fix bug
sed -i '/interface}/d' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
sed -i 's/"终端"/"TTYD 终端"/g' feeds/luci/applications/luci-app-ttyd/po/zh_Hans/ttyd.po

# Boost UDP
echo '# optimize udp' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.rmem_max=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.rmem_default=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.wmem_max=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.wmem_default=26214400' >>package/base-files/files/etc/sysctl.d/10-default.conf
echo 'net.core.netdev_max_backlog=2048' >>package/base-files/files/etc/sysctl.d/10-default.conf

# upgrade 99-default-settings-chinese.sh
rm -rf package/emortal/default-settings/files/99-default-settings-chinese.sh
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/1mm0rt4lwrt/99-default-settings-chinese.sh -O package/emortal/default-settings/files/99-default-settings-chinese.sh

# add init settings
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/1mm0rt4lwrt/99-init-settings -O package/base-files/files/etc/uci-defaults/98-updata-settings
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/1mm0rt4lwrt/30-sysinfo.sh -O feeds/packages/utils/bash/files/etc/profile.d/30-sysinfo.sh

# Change to my banner
sudo rm package/base-files/files/etc/banner
wget --no-check-certificate https://raw.githubusercontent.com/0xACE8/hyp3r-v_x64/main/1mm0rt4lwrt/banner -O package/base-files/files/etc/banner

echo "diy-part3.sh is done."
