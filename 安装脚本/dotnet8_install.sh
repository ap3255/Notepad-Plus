#!/bin/bash

# ===== 配置变量 =====
SDK_URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.408/dotnet-sdk-8.0.408-linux-arm64.tar.gz"
SDK_FILE="dotnet-sdk-8.0.408-linux-arm64.tar.gz"
DOTNET_ROOT="/opt/.dotnet"
ENV_FILE="/etc/environment"

# ===== 下载文件 =====
echo "开始下载 .NET SDK..."
wget -c "$SDK_URL" -O "$SDK_FILE" || {
    echo "错误：下载失败（可能因系统内部异常或网络问题）"
    exit 1
}

# ===== 解压缩 =====
echo "开始解压缩..."
mkdir -p "$DOTNET_ROOT"
tar -zxf "$SDK_FILE" -C "$DOTNET_ROOT" || {
    echo "错误：解压缩失败"
    exit 1
}

# ===== 配置环境变量 =====
echo "配置环境变量..."
export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"

# 持久化环境变量到系统配置
if ! grep -q "$DOTNET_ROOT" "$ENV_FILE"; then
    echo "export PATH=\"\$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools\"" >> "$ENV_FILE"
    echo "已将 .NET 路径添加到 $ENV_FILE"
else
    echo ".NET 路径已存在于环境变量中"
fi

# 立即生效配置
source "$ENV_FILE"

# ===== 验证安装 =====
echo "验证安装..."
dotnet --version && echo "安装成功：$(dotnet --version)" || {
    echo "错误：安装验证失败，请检查日志"
    exit 1
}
