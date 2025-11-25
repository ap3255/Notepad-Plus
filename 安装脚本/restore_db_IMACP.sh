#!/bin/bash

# 数据库配置（确保密码和 postgres 用户一致）
password="Qirobot@2025.06"  # 和你设置的 postgres 密码保持一致
username="postgres"
dbname="IMACP"
backup_file="IMACP_20251120.backup"  # 指定要恢复的备份文件

# 检查备份文件是否存在
if [ ! -f "$backup_file" ]; then
    echo "错误：备份文件 $backup_file 不存在！"
    exit 1
fi

# 1. 创建 IMACP 数据库（如果已存在会提示错误，可忽略）
echo "正在创建数据库 $dbname..."
sudo PGPASSWORD="$password" psql -h localhost -U "$username" -c "CREATE DATABASE \"$dbname\";"

# 2. 执行恢复命令
echo "正在从 $backup_file 恢复数据库..."
sudo PGPASSWORD="$password" pg_restore -h localhost -U "$username" -d "$dbname" "$backup_file"

# 3. 检查恢复结果
if [ $? -eq 0 ]; then
    echo "数据库恢复成功！使用的备份文件：$backup_file"
else
    echo "数据库恢复失败，请检查密码和备份文件是否正确。"
fi