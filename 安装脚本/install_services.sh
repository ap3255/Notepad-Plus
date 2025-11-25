#install_back

sudo mv ./qirobot.host.service /lib/systemd/system/
sudo mv ./qirobot.iothub.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable qirobot.host.service
sudo systemctl enable qirobot.iothub.service
sudo systemctl restart qirobot.host.service
sudo systemctl restart qirobot.iothub.service

sudo systemctl status qirobot.host.service
sudo systemctl status qirobot.iothub.service