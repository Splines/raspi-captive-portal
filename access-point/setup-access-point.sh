#!/bin/sh

# Sources / Inspiration
# https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-routed-wireless-access-point
# https://github.com/TomHumphries/RaspberryPiHotspot

# --- Install
sudo apt-get update
# dhcpcd is a DHCP client. It should come pre-installed by default, but that
# was not the case for me when installing the new Bookworm Raspi OS. That's
# why we play it safe and install it here (again).
sudo apt-get install -y dhcpcd
# HostAPD access point software and DNS/DHCP via DNSMasq
sudo apt-get install -y dnsmasq
sudo apt-get install -y hostapd
# Utility to save firewall rules and restoring them when the Pi boots
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y netfilter-persistent iptables-persistent

# Stop services since configuration files are not ready yet
sudo systemctl stop dnsmasq
sudo systemctl stop hostapd

# Raspberry Pi acts as router on wirless network
# As it runs a DHCP Server, the Raspi needs a static IP address
cat ./access-point/dhcpcd.conf | sudo tee -a /etc/dhcpcd.conf > /dev/null
sudo systemctl restart dhcpcd

# --- Configure DHCP server (dnsmasq)
if test -f /etc/dnsmasq.conf; then
    # Backup file
    sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
fi
sudo cp ./access-point/dnsmasq.conf /etc/dnsmasq.conf

# Don't let dnsmasq alter your /etc/resolv.conf file
# https://raspberrypi.stackexchange.com/questions/37439/proper-way-to-prevent-dnsmasq-from-overwriting-dns-server-list-supplied-by-dhcp
echo "DNSMASQ_EXCEPT=lo" | sudo tee -a /etc/default/dnsmasq > /dev/null

sudo systemctl unmask dnsmasq.service
sudo systemctl enable dnsmasq.service
sudo systemctl restart dnsmasq

# --- Routing and masquerade
# Activate IPv4 package forwarding
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
# Add redirect for all inbound http traffic for 192.168.4.1
# (which we defined earlier in dnsmasq.conf)
# to our Node.js server on port 3000 (192.168.4.1:3000)
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:3000

# Comment out this line if you want to access the Pi via SSH when being connected
# to the Wifi Access Point. You can use: ssh -i "path/to/private/key/file" pi@192.168.4.1
# sudo iptables -t nat -I PREROUTING -p tcp --dport 22 -j ACCEPT

# Save to be loaded at boot by the netfilter-persistent service
sudo netfilter-persistent save

# --- Configure access point (hostapd)
# Make sure wlan is not blocked on raspi
sudo rfkill unblock wlan
sudo cp ./access-point/hostapd.conf /etc/hostapd/hostapd.conf
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd
