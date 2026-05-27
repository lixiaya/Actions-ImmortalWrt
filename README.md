# ImmortalWrt 25 — Cudy TR3000 自动编译

基于 [ImmortalWrt 25.12](https://github.com/immortalwrt/immortalwrt) (openwrt-25.12)，目标设备 **Cudy TR3000**（MT7981B / Filogic）。

**已集成：**
- Linux 6.12 + eBPF/BTF，支持 dae / daed 透明代理
- apk 包管理、nftables + firewall4
- 开源 mt76 WiFi 驱动

## 使用步骤

### 一键编译

1. fork 本仓库
2. 进入 Actions → `🚀 编译 ImmortalWrt 25` → Run workflow
3. 选择是否开启多线程（默认开启），点击绿色的 Run workflow
4. 等待约 2-3 小时，编译完成后在 Summary 页面下载 `ImmortalWrt-Cudy-TR3000` 固件

### SSH 调试编译

勾选 `使用 SSH 连接到编译环境`，workflow 会在 `feeds update/install` 后暂停并输出 SSH 连接信息，可手动调试后再退出自动编译。

## 文件说明

| 文件 | 用途 |
|------|------|
| `.config` | 编译配置（Target/插件/内核选项） |
| `feeds.conf.default` | feeds 源列表 |
| `diy.sh` | 编译前自定义脚本（可添加第三方插件） |

## 自定义配置

如需修改编译选项：

1. 本地克隆 ImmortalWrt：
   ```shell
   git clone https://github.com/immortalwrt/immortalwrt.git -b openwrt-25.12
   ```
2. 更新 feeds 并配置：
   ```shell
   cd immortalwrt
   ./scripts/feeds update -a && ./scripts/feeds install -a
   make menuconfig
   ```
3. 保存后将 `.config` 上传到本仓库替换即可
