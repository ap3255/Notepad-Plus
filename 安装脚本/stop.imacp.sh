#!/bin/bash

# 定义要重启的服务列表
services=("nginx" "qirobot.host" "qirobot.iothub")

# 遍历服务列表
for service in "${services[@]}"; do
    # 检查服务是否存在
    if systemctl list-units --full -all | grep -Fq "$service.service"; then
        # 尝试重启服务
        if systemctl stop "$service"; then
            echo "$service 服务停止成功。"
        else
            echo "$service 服务停止失败，请检查日志获取更多信息。"
        fi
    else
        echo "$service 服务不存在。"
    fi
done
