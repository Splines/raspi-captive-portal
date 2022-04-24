<p align="center">
  <img src="https://user-images.githubusercontent.com/37160523/164785388-abe36954-6b33-4b1d-a001-46072f68cb99.svg" width="1000px" />
  
  <h3 align="center">Raspi Captive Portal</h3>
  <p align="center">A Captive Portal & Access Point setup for use with the Raspberry Pi</p>
</p>


## Motivation

Ever connected to a WiFi network in public space? You've probably been redirected to a page where you had to agree to the terms of use to gain access to the Internet. This web page is called *Captive Portal*.

[This Raspi documentation](https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-routed-wireless-access-point) offers a starting point to set up a captive portal on your own. However, it's tedious. And it's a lot of digging through documentation to figure out how to populate those config files properly. And then things don't work as expected and suddenly you've spent another three hours (more!) trying to get a basic access point to run. Why not make your life easier?

| :star:   | If this project indeed made your life easier, consider giving a GitHub star. |
|---------------|:-------------------------|

## What you get

**This repo offers you a complete setup for an access point with a captive portal, but without Internet access.** Instead, you can serve a static HTML page to people connecting to your WiFi network. See my project [`raspi-captive-circle`](https://github.com/Splines/raspi-captive-circle) as a full project example where users can play a game in a captive portal together.

You probably want to use this repo in one of these ways:

- As a starting point for your own project using an access point and/or captive portal. See the installation instructions in this case. Check out my [medium post](https://dominicplein.medium.com/captive-portal-access-point-on-the-raspberry-pi-easy-setup-28a9bf72e998) to get some ideas for a project.
- As a resource to get inspired by and to consult if you are stuck. The code contains links to other useful resources like package documentations, stack overflow questions etc.

## Setup

<details>
  <summary><strong>Installation</strong></summary>

  If you connect to the Raspberry Pi from remote, make sure to do so via Ethernet an NOT via WiFi as the setup script will create its own WiFi network and thus you won't be connected anymore (and maybe even lock yourself out of your Raspi). Python is installed by default on a Raspberry Pi, so clone this repository and execute the script via:

  <sub>Note that the script needs to run as sudo user. Make sure that you agree with the commands executed beforehand by looking into the `.sh` scripts in the folder `access-point/`. Setup script was tested with a fresh install of Raspbian GNU/Linux 11 (bullseye) on the Raspberry Pi 4.</sub>

  ```
  git clone https://github.com/Splines/raspi-captive-portal.git
  cd ./raspi-captive-portal/
  sudo python setup.py
  ```

</details>

<details>
  <summary><strong>Connection</strong></summary>

  After the installation, you should be able to connect to the new WiFi network called `Splines Raspi AP` using the password `splines-raspi`. You should be redirected to a static welcome page. If you open a "normal" browser, type in any http URL (http**s** URLs are not working) and you should also get redirected to the static page. The URL is supposed to read `splines.portal`.

</details>


<details>
  <summary><strong>Customization</strong></summary>

  To customize the WiFi SSID, password and the like, simply change the respective key-value pairs in the config files inside the folder `access-point/`. Adjust server settings in the file `server/src/server.ts`.

  Some default values:

  - static ip for the raspi: `192.168.4.1/24`
  - using `wlan0` as interface
  - WiFi: SSID: `Splines Raspi AP`, password: `splines-raspi`, country code: `DE` (change if you are not living in Germany)
  - Server: port: `3000` (all request on port 80 (http) get redirected to this port), host name: `splines.portal`

</details>


<details>
    <summary><strong>Troubleshooting</strong></summary>

If this first assistance does not help, feel free to open a new issue.

**I can't connect to the `Splines Raspi AP` WiFi or get thrown out**

Double check that you've entered the correct password: `splines-raspi`. Also, the Raspberry Pi won't provide Internet acceess to you, it will just serve a static HTML page for the game. This is why you might get thrown out of the WiFi network. If this is the case, there is usually an option to "Use this network without Internet access" (or the like). It might also help to disable mobile data.

**How can I use a "normal" browser when I have to click "Cancel" in the captive portal?**

The Raspberry Pi serves as Access Point and does not provide Internet access to you. Therefore on the captive portal you might have to click "cancel" (e.g. on iOS) and then "Use this network without Internet access" (or the like). After that, you can open any "real" browser on your phone, e.g. Chrome, Firefox, Safari (and so forth), and go to the website `splines.portal`.

**I don't see the `Splines Raspi AP` WiFi network**

Make sure that everything worked fine in the installation script. Check the output of hostapd (host access point daemon), has it started correctly?

```
sudo systemctl status hostapd
```

If it failed try to restart it:

```
sudo systemctl restart hostapd
```

If this also fails, try to reboot the Raspberry Pi and check again:

```
sudo restart
```

**I see the `Splines Raspi AP` WiFi network, but the web page doesn't show up**

Access the URL `splines.portal` in your browser. Also make sure that the server serving the static HTML pages is up and running:

```
sudo systemctl status access-point-server
```

The output should contain this line: "⚡ Raspberry Pi Server listening on port 3000". Any error here? Try to restart the service:

```
sudo systemctl restart access-point-server
```


</details>


## Other

<details>
  <summary><strong>Dependencies</strong></summary>

  These are the principal dependencies used in this project:

  *Captive Portal*
  - `hostapd`: Access Point (AP)
  - `dnsmasq`: Provide DHCP server (automatically assign IP addresses to clients) and DNS server (name resolution)
  - `netfilter-persistent` & `iptables-persistent`: Save firewall rules and restore them when the Raspberry Pi boots

  *Node.js Server*
  - `express` 

</details>

<details>
    <summary><strong>License</strong></summary>

This program is licensed with the very permissive MIT license, see the [LICENSE file](https://github.com/Splines/raspi-captive-portal/blob/main/LICENSE) for details. As this is only a small project, I don't require you to include the license header in every source file, however you must include it at the root of your project. According to the MIT license you must also include a copyright notice, that is, link back to this project, e.g. in this way:

> [Captive Portal & Access Point setup](https://github.com/Splines/raspi-captive-portal) - Copyright (c) 2022 Splines

Any questions regarding the license? [This FAQ](https://www.tawesoft.co.uk/kb/article/mit-license-faq) might help.

The logo of this project is exempt from the MIT license and you must not use it in any of your work. Icons used in the logo are bought from thenounproject.com ([1](https://thenounproject.com/icon/raspberry-pi-1109535/) and [2](https://thenounproject.com/icon/wifi-170991/)).

</details>
