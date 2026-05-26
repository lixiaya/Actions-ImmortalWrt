# MEMORY.md — Actions-ImmortalWrt 项目长期记忆

## 项目基本信息
- **类型**：ImmortalWrt GitHub Actions 自动编译
- **目标设备**：Cudy TR3000 256MB v1
- **平台**：mediatek/filogic，aarch64_cortex-a53
- **内核**：Linux 6.12
- **ImmortalWrt 源码分支**：openwrt-25.12

## 关键功能需求
- BTF 支持（`CONFIG_KERNEL_DEBUG_INFO_BTF=y`）
- daed 透明代理（`CONFIG_PACKAGE_daed=y` + `CONFIG_PACKAGE_luci-app-daed=y`）
- APK 包管理器（`CONFIG_PACKAGE_apk-openssl=y`）
- BPF 支持（`CONFIG_KERNEL_BPF_SYSCALL=y`、`CONFIG_KERNEL_BPF_JIT=y`）

## 已知问题 & 修复记录
1. **2026-05-25 v1**：workflow 中直接跑包编译导致 `libdeflate-gzip: No such file or directory`
   - 原因：跳过了 host 工具链构建步骤
   - 修复：删除单独的 mac80211 预编译步骤
2. **2026-05-25 v2**：mt76 编译失败，缺少 `backport/autoconf.h`
   - 原因：手动 `make tools/install && make toolchain/install` 后 mac80211 用 allnoconfig 编译，头文件未生成
   - 修复：删除手动工具链步骤，改用 `make download` + `make world` 让 OpenWrt 自动处理依赖链
   - **核心原则：不要手动干预 OpenWrt 的编译依赖顺序**

## 文件结构
- `.config`：6827 行，已包含所有必要的 BTF/BPF/daed 配置
- `feeds.conf.default`：使用 immortalwrt openwrt-25.12 分支
- `diy.sh`：目前基本为空（只有注释）
- `.github/workflows/build.yml`：两个 job（build / build-ssh）
