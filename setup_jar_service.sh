#!/bin/bash

# 参数配置（修改以下变量）
SERVICE_NAME="DBSyncer"           # 服务名称（如 myapp）
JAR_PATH="/opt/DBSyncerService/dbsyncer-web-2.0.7.jar"  # JAR 文件绝对路径
RUN_USER="root"                # 运行用户（建议改为专用用户）
WORK_DIR=$(dirname "$JAR_PATH") # JAR 所在目录

# 检查 root 权限
if [ "$(id -u)" -ne 0 ]; then
  echo "请使用 root 用户运行此脚本！"
  exit 1
fi

# 检查 JAR 文件是否存在
if [ ! -f "$JAR_PATH" ]; then
  echo "错误：JAR 文件不存在 ($JAR_PATH)"
  exit 1
fi

# 创建 systemd 服务文件
create_service() {
  cat > "/etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=$SERVICE_NAME (Java Application)
After=network.target

[Service]
User=$RUN_USER
WorkingDirectory=$WORK_DIR
ExecStart=/usr/bin/java $JAVA_OPTS -jar $JAR_PATH
SuccessExitStatus=143
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

  echo "服务文件已创建: /etc/systemd/system/${SERVICE_NAME}.service"
}

# 设置权限
set_permissions() {
  chown "$RUN_USER:$RUN_USER" "$JAR_PATH"
  chmod 755 "$JAR_PATH"
  echo "已设置权限: $JAR_PATH → 用户: $RUN_USER"
}

# 主流程
main() {
  echo "正在设置服务: $SERVICE_NAME"
  create_service
  set_permissions

  # 重载 systemd
  systemctl daemon-reload
  systemctl enable "$SERVICE_NAME"
  systemctl start "$SERVICE_NAME"

  echo "服务已启动并启用开机自启！"
  echo "管理命令:"
  echo "  sudo systemctl status $SERVICE_NAME"
  echo "  sudo systemctl stop $SERVICE_NAME"
  echo "  sudo systemctl restart $SERVICE_NAME"
}
# 执行主流程
main
