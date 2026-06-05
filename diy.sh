# 请在下方输入自定义命令(一般用来安装第三方插件)(可以留空)
# Please enter the custom command below (usually used to install third-party plugins) (can be left blank)

# dae/daed 已包含在 ImmortalWrt 官方 packages feed 中，无需额外克隆
# 如需自定义命令在此添加（如安装第三方插件）
# git clone --depth=1 https://github.com/xxx/xxx.git package/xxx

# 默认 LAN IP 改为 10.0.0.1
sed -i "s/192\.168\.1\.1/10.0.0.1/g" package/base-files/files/bin/config_generate
