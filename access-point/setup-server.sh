sudo cp ./access-point-server.service /etc/systemd/system/
sudo systemctl enable access-point-server

# Start service immediately
sudo systemctl start access-point-server
