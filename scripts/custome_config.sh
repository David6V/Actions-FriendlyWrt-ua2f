#!/bin/bash

# === 原有配置保持不变 ===
sed -i -e '/CONFIG_MAKE_TOOLCHAIN=y/d' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_IB=y/# CONFIG_IB is not set/g' configs/rockchip/01-nanopi
sed -i -e 's/CONFIG_SDK=y/# CONFIG_SDK is not set/g' configs/rockchip/01-nanopi

# === 新增：克隆 UA2F 相关源码 ===
git clone --depth=1 https://github.com/Zxilly/UA2F.git package/ua2f
git clone --depth=1 https://github.com/Zxilly/luci-app-ua2f.git package/luci-app-ua2f

# === 新增：UA2F 最小必要编译配置 ===
cat >> configs/rockchip/01-nanopi <<EOF

# --- UA2F 核心 ---
# ua2f 的 Makefile 会自动处理 iptables-mod-u32 和 kmod-ipt-u32 依赖
CONFIG_PACKAGE_ua2f=y
CONFIG_PACKAGE_luci-app-ua2f=y

# --- UA2F 运行时依赖 ---
CONFIG_PACKAGE_libcap=y
CONFIG_PACKAGE_libcap-bin=y
EOF
