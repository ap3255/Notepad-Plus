#!/bin/bash

# 更新软件包列表
sudo apt update

# 安装 Nginx
sudo apt install -y nginx

# 检查 Nginx 是否安装成功
if [ $? -eq 0 ]; then
    echo "Nginx 安装成功"
    # 启动 Nginx 服务
    sudo systemctl restart nginx
    # 设置 Nginx 开机自启
    sudo systemctl enable nginx
    echo "Nginx 已启动并设置为开机自启"

    # 假设自定义的 nginx.conf 文件在当前目录下
    CUSTOM_NGINX_CONF="./nginx.conf"
    DEFAULT_NGINX_CONF="/etc/nginx/nginx.conf"

    if [ -f "$CUSTOM_NGINX_CONF" ]; then
        sudo cp "$CUSTOM_NGINX_CONF" "$DEFAULT_NGINX_CONF"
        if [ $? -eq 0 ]; then
            echo "成功覆盖 Nginx 默认配置"
            # 检查配置文件语法
            sudo nginx -t
            if [ $? -eq 0 ]; then
                # 重新加载 Nginx 服务以应用新配置
                sudo systemctl reload nginx
                echo "Nginx 已重新加载配置"
            else
                echo "Nginx 配置文件语法检查失败，请检查配置文件"
            fi
        else
            echo "覆盖 Nginx 默认配置失败"
        fi
    else
        echo "自定义的 nginx.conf 文件不存在，请检查文件路径"
    fi
else
    echo "Nginx 安装失败"
fi    
