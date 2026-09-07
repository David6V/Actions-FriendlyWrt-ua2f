#!/bin/bash

CONFIGS=(
  # === 原有配置 ===
  "CONFIG_NET_ACT_CT=m"
  "CONFIG_NET_ACT_CTINFO=m"

  # === UA2F / xt_u32 所需内核选项 ===
  # u32 匹配模块核心依赖
  "CONFIG_NETFILTER_XT_MATCH_U32=m"

  # xt_u32 隐式依赖的 netfilter 基础设施
  "CONFIG_NETFILTER_ADVANCED=y"
  "CONFIG_NF_CONNTRACK=y"

  # libcap 所需的内核能力支持
  "CONFIG_SECURITY_CAPABILITIES=y"
)

source .current_config.mk
KCFG=kernel/arch/arm64/configs/$(awk '{print $1}' <<< "$TARGET_KERNEL_CONFIG")

for CFG in "${CONFIGS[@]}"; do
  KEY=${CFG%%=*}
  if grep -q "^#\?${KEY}=" "${KCFG}"; then
    sed -i "s@^#\?${KEY}=.*@${CFG}@g" "${KCFG}"
  else
    echo "$CFG" >> "${KCFG}"
  fi
done
