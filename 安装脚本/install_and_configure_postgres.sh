#!/bin/bash

# 1. 安装 PostgreSQL 16 服务
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

# 添加 PostgreSQL 官方 APT 仓库s
# Import the repository signing key:
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

# Create the repository configuration file:
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"

# 更新包列表
sudo rm -rf /etc/apt/sources.list.d/pgdg.sources
sudo rm -rf /etc/apt/apt.conf.d/02autoremove-pos
sudo rm -rf /etc/apt/apt.conf.d/02autoremove-postgresql
sudo apt update

# 安装 PostgreSQL 16
sudo apt -y install postgresql-16

# 启动并设置开机自启
sudo systemctl start postgresql
sudo systemctl enable postgresql

# 2. 允许远程连接
# 修改 postgresql.conf 以监听所有地址
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/16/main/postgresql.conf

# 修改 pg_hba.conf 以允许所有 IP 地址的连接
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf

# 重启 PostgreSQL 服务使配置生效
sudo systemctl restart postgresql

# 3. 修改 pgsql 密码
# 获取当前年份和月份
year=$(date +%Y)
month=$(date +%m)
password="Qirobot@$year.$month"

# 以 postgres 用户身份修改密码
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$password';"

# 验证密码是否修改成功
echo "密码已修改为: $password"