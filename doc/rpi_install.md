# Installation of KlinikDB on an Raspberry Pi

## Installing the OS

The LAMP stack behind KlinikDB could be installed on any OS. The
Raspberry Pi is usually installed with Noobs or Raspbian, which are
Debian derivatives. However in the following Arch Linux is used, due
to its smaller size, and my greater familiarity with Arch.  The
following details are for the installation of ArchLinuxARM on a
Raspberry Pi 4B (2021-03-02).

 1. Start here:
    <https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4>
    and follow the AArch64 Installation instructions 1-6. Test the
    integrity of the download with `md5sum`. Compare with the
    `xxx.md5` file in <http://os.archlinuxarm.org/os/rpi/> before
    installing in step 5.
 2. Edit `/boot/config.txt` to add the line: `dtoverlay=gpio-shutdown`
    to the file. This will permit the shorting of pins 5 and 6 (the
    defaults) to trigger a shutdown. The subsequent shorting of these
    pins while the system is shutdown (but connected to power) will
    trigger a power-on event.
 3. Continue with steps 7-10. Remember to correct `mmcblk0` to
    `mmcblk1` as per the AArch64 note.
 4. Connect a display via the micro HDMI (the one nearest the USB3
    power port), and a keyboard.  Alternatively, connect via ethernet
    with a router, and after boot determine the RPi’s IP using the
    router’s admin panel. Then ssh to that IP (ssh access is enabled
    in the initial distro).
 5. Plug in a USB2 power supply to the RPi board.
 6. Login: `alarm`, password: `alarm`, then `su` to root, password
    `root`
 7. If not using ethernet, set up a wireless connection to the
    internet with `wifi-menu`
 8. Finish up setup: `pacman-key --init` and `pacman-key --populate
    archlinuxarm`.
 9. Update system: `pacman -Syu` 

## Finish basic setup

(All commands as root, unless indicated.)
    
    pacman -S emacs-nox
    timedatectl set-timezone "Africa/Nairobi" # or yours
    emacs /etc/locale.gen          # uncomment en_US.UTF-8 UTF-8
    locale-gen
    emacs /etc/locale.conf         # LANG=en_US.UTF-8
    emacs /etc/hostname            # myhostname
    emacs /etc/hosts
    cat /etc/hosts
      127.0.0.1   localhost
      ::1         localhost
      127.0.1.1   myhostname.localdomain  myhostname
    passwd   # set root password
    systemctl mask systemd-journald-audit.socket  # kill the audit system
                                                  # to save space in journal

Reboot: 

    shutdown -r now  # or just /usr/bin/reboot
 
Set up firewall: 

    pacman -S ufw
    systemctl start ufw
    systemctl enable ufw
    ufw allow SSH
    ufw allow WWW
    ufw enable
    ufw logging off

During setup, you can enable wifi access at startup with `netctl
enable wlan0-SSID`.  However, if using `wlan0` as the access point for
the klinikDB (see below), remember to disable this so that it does not
clash with settings in `systemd-networkd`.

SSHing in may give trouble with terminal commands. Add `TERM=vt100` to
`~/.bash_profile` for both user and root.

Now install some core packages:

    pacman -S man rsync lynx git

## Wifi access point

We will configure the RPi to offer a local intranet (on 10.0.0.*) via
the built-in wifi (`wlan0`), using `hostapd` and leasing IPs with
`dhcpd`. To connect to the internet, the ethernet port (`eth0`) must
be connected, which will automatically seek an IP address via
DHCP. Thanks to these posts for tips ([1][1], [2][4], [3][5], [4][6],
[5][7]). I could not get WPA to work reliably, so am leaving the
connection open. Data access is passwork protected. At a later date,
MAC address filtering would be a secure option.

Get the needed packages:

    pacman -S hostapd dhcp

First we need to set a static IP for `wlan0`. The direct, CLI way is:
`ip link set wlan0 down ; ip addr flush dev wlan0 ; ip link set wlan0
up ; ip addr add 10.0.0.1/24 dev wlan0`, but this can more easily be
done in `systemd`, which is started by default on Arch, and which sets
`eth0` to connect via DHCP. 

    emacs /etc/systemd/network/wlan0.network`

      [Match]
      Name=wlan0
      
      [Network]
      Address=10.0.0.1/24

Restart the service with: `systemctl restart systemd-networkd` and
check the IP of `wlan0`: it should say: `inet 10.0.0.1/24`. The new
configuration will be initialized at startup.

Now we need an access point, with security. 

    emacs /etc/hostapd/hostapd.conf

      interface=wlan0
      driver=nl80211
      ssid=klinikdb
      hw_mode=g
      channel=6
      macaddr_acl=0
      ignore_broadcast_ssid=0
      auth_algs=3

(For WPA the additional minimal options would be `wpa=2`,
`wpa_passphrase=XXXXXXXX`, `wpa_key_mgmt=WPA-PSK`,
`wpa_pairwise=TKIP`, `rsn_pairwise=CCMP`.)

Finally, we need a DHCP server. 

    emacs /etc/dhcpd.conf

      option subnet-mask 255.255.255.0;
      option routers 10.0.0.1;
      subnet 10.0.0.0 netmask 255.255.255.0 {
        range 10.0.0.2 10.0.0.20;
      }

(Note, adding a `subnet 192.168.1.0 netmask 255.255.255.0 { \n }`
could prevent DHCP requests coming in from `eth0`; see [here][2].)

Start, and enable the new services at start-up:

    systemctl start hostapd
    systemctl enable hostapd
    systemctl start dhcpd4
    systemctl enable dhcpd4

Reboot the system to see if you can connect. If it is failing, you can
always connect the RPi via ethernet and SSH in that way.

## Hardware clock

The RPi has no built-in battery clock, and relies on the internet’s
NTP to set the time at each boot. If the RPi will often be running off
the ‘net, then a battery clock module is needed. I bought a DS1307 RTC
Board (USD 3.95 at pishop.us).

Testing (not for permanent installation):

    emacs /boot/config.txt     # add dtparam=i2c_arm=on
    pacman -S i2c-tools
    reboot
    modprobe i2c-dev
    modprobe i2c-bcm2835
    lsmod | grep i2c
    modprobe rtc-ds1307
    lsmod | grep rtc
    i2cdetect -y 1
    echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
    dmesg | grep rtc
    
    timedatectl     
    hwclock --show   # error until set
    hwclock --set --date "2021-03-16 15:42:00 +0"
    hwclock --show  
    hwclock -s      
    timedatectl     

Permanent installation:

    emacs /boot/config.txt     # add dtparam=i2c_arm=on
    pacman -S i2c-tools
    reboot
    emacs /etc/modules-load.d/raspberrypi.conf
    cat   /etc/modules-load.d/raspberrypi.conf
      i2c-dev
      i2c-bcm2835
      rtc-ds1307
    
    mkdir -p /usr/lib/systemd/scripts/
    emacs /usr/lib/systemd/scripts/rtc
    cat   /usr/lib/systemd/scripts/rtc
      #!/bin/bash
      echo ds1307 0x68 > /sys/class/i2c-adapter/i2c-1/new_device
      hwclock -s
    chmod 755 /usr/lib/systemd/scripts/rtc
    emacs /etc/systemd/system/rtc.service
    cat   /etc/systemd/system/rtc.service
      [Unit]
      Description=RTClock
      Before=network.target
      
      [Service]
      ExecStart=/usr/lib/systemd/scripts/rtc
      Type=oneshot
      
      [Install]
      WantedBy=multi-user.target
    systemctl enable rtc
    reboot

The very beginning of the boot will always be a fake (old) date, but
as the services start to be activated, the correct date will be
adopted and the system journal will correct itself.

See online posts [1][8], [2][9], [3][10].

## Mariadb

    pacman -S mariadb
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    systemctl start mysql
    systemctl enable mysqld
    mysql_secure_installation    # set a root password, all else default (Y)
    
    mysql -u root -p
       MariaDB > CREATE USER 'pi'@'localhost' IDENTIFIED BY 'XXXX';
       MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'pi'@'localhost';
       MariaDB > FLUSH PRIVILEGES;
    
    su alarm
    mysql -u pi -p    # use password XXXX
      MariaDB > CREATE DATABASE klinikdb CHARSET 'utf8' COLLATE 'utf8_bin';
      
Get and load klinikDB:

    su alarm
    cd ~
    git clone https://github.com/camwebb/klinikDB.git
    mysql -u pi -p klinikdb < /home/alarm/klinikDB/sql/klinikDB.sql

## Web server

    pacman -S apache
    emacs /etc/httpd/conf/httpd.conf 
    
Make these changes to `/etc/httpd/conf/httpd.conf` (`diff` formatted):

      < LoadModule mpm_event_module modules/mod_mpm_event.so
      < #LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
      ---
      > #LoadModule mpm_event_module modules/mod_mpm_event.so
      > LoadModule mpm_prefork_module modules/mod_mpm_prefork.so

      < #LoadModule cgi_module modules/mod_cgi.so
      ---
      > LoadModule cgi_module modules/mod_cgi.so
      
      < #LoadModule rewrite_module modules/mod_rewrite.so
      ---
      > LoadModule rewrite_module modules/mod_rewrite.so
      
      < DocumentRoot "/srv/http"
      < <Directory "/srv/http">
      ---
      > DocumentRoot "/home/alarm/klinikDB/web"
      > <Directory "/home/alarm/klinikDB/web">
      
      <     AllowOverride None
      ---
      >     AllowOverride All

At the end of Modules, add:
      
      > LoadModule php7_module modules/libphp7.so
      > AddHandler php-script .php

At the end of the file, add:

      > Include conf/extra/php7_module.conf

Save, and:

    systemctl start httpd
    systemctl enable httpd
    
Use `journalctl` or `systemctl status httpd` to check that it started.
    
    chmod a+rx /home/alarm/

Test from inside:

    curl http://localhost/

should give the HTML contents of the klinikDB homepage

Test from outside, in a browser (or curl):

    http://XXX.XXX.XXX.XXX/

should give the same.

## PHP

PHP is needed for Xataface, the framework that drives the GUI for the
database.

   pacman -S php7 php7-apache
   emacs /etc/php7/php.ini 

      < ;extension=mysqli.so
      ---
      > extension=mysqli.so
      
      < ;extension=pdo_mysql.so
      ---
      > extension=pdo_mysql.so
      
      < ;date.timezone =
      ---
      > date.timezone = Africa/Nairobi

    systemctl restart httpd

## KlinikDB database

    cd ~/klinikDB/web/db/
    cp conf_template.ini conf.ini   #_
    emacs conf.ini

Set:

    host = "localhost"      
    user = "pi"     
    password = "XXXXXXXX"   
    name = "klinikdb"

Install xataface. Go to <https://github.com/shannah/xataface/> and get
the latest version. E.g.:

    cd ~/klinikDB/web/db/
    curl -LO https://github.com/shannah/xataface/archive/2.2.5.tar.gz
    tar xvzf 2.2.5.tar.gz 
    mv xataface-2.2.5/ xataface
    rm 2.2.5.tar.gz 

    mkdir templates_c
    chmod a+w templates_c   #_

No try <http://localhost/db> and you should see the login screen.

## Tools and system control via the website

System shutdown:

    pacman -S sudo
    EDITOR=emacs visudo  # Add: http ALL = (ALL) NOPASSWD: /usr/bin/poweroff

      http ALL = (alarm) NOPASSWD: /usr/bin/ssh *
      http ALL = (alarm) NOPASSWD: /usr/bin/kill *

Backup as encryped file:

    pacman -S gnupg
    su alarm
    gpg --gen-key
    gpg --import cw-pub.asc 
    gpg --import hih-pub.asc 
    cp ~/.gnupg/pubring.kbx ~/klinikDB/gnupg
    echo "foo" > test
    gpg -e -a --trust-model always -r cw@camwebb.info \
      -r gpg@healthinharmony.org --homedir klinikDB/gnupg/ \
      --no-permission-warning test 
    chmod a+w klinikDB/backup

Networking to the internet for remote access:

    pacman -S sudo
    EDITOR=emacs visudo  # Add: http ALL = (alarm) NOPASSWD: /usr/bin/ssh *
                         #      http ALL = (alarm) NOPASSWD: /usr/bin/kill *
    su alarm
    ssh-keygen
    scp .ssh/id_rsa.pub bbbr_remote@phylodiversity.net:.
    ssh bbbr_remote@phylodiversity.net
    remote$ mv id_rsa.pub .ssh/authorized_keys 
    remote$ logout
    ssh -R 20000:127.0.0.1:22 bbbr_remote@phylodiversity.net # to test

## Change passwords    

Now the system is set up, change the default root and alarm passwords.

----

## Power monitoring

Since the KlinikDB Raspberry Pi will be often powered by a battery
powerpack, it is important to implement some code that triggers a safe
shutdown when the input voltage drops below a threshold.  The RPi
has an internal low voltage monitor that shows a red symbol via the
HDMI monitor, but this is not useful when running headless.  

Earlier models triggered a voltage change on GPIO pin 35, but this is
apparently no longer active. (As a side note, I
[discovered](https://raspberrypi.stackexchange.com/a/121903/103399) that
the legacy access to GPIO status using `sysfs` is probably being
dropped from newer kernels. The character device ABI, using
`/dev/gpiochip[0-9]+` is the new way to access GPIOs. On Arch, the
`gpio-utils` package offers `lsgpio`, etc as easy CLI tools for
interacting with GPIOs.)

However, the `raspberrypi_hwmon` checks for this low-voltage state,
which can then be discovered with `vcgencmd
get_throttled`. [`powermon.sh`](powermon.sh) is a simple script that
can be run as a `cron` job, and will trigger a shutdown on a
low-voltage condition. To install:

Check for `raspberrypi_hwmon` module:

    # lsmod | grep raspberrypi_hwmon

    # pacman -S raspberrypi-firmware cronie
    # curl -LO https://raw.githubusercontent.com/camwebb/klinikDB/main/\
        doc/powermon.sh
    # chmod u+x powermon.sh
    # mkdir bin
    # mv powermon.sh bin
    
    # systemctl start cronie
    # systemctl enable cronie
    
    # EDITOR=emacs crontab -e
    # crontab -l
      * * * * *  /root/bin/powermon.sh


[1]: https://nims11.wordpress.com/2012/04/27/hostapd-the-linux-way-to-create-virtual-wifi-access-point/     
[2]: https://wiki.archlinux.org/index.php/Dhcpd
[4]: https://www.linux.com/training-tutorials/create-secure-linux-based-wireless-access-point/
[5]: https://wireless.wiki.kernel.org/en/users/Documentation/hostapd
[6]: https://gist.github.com/renaudcerrato/db053d96991aba152cc17d71e7e0f63c
[7]: https://hawksites.newpaltz.edu/myerse/2018/06/08/hostapd-on-raspberry-pi/
[8]: https://wiki.52pi.com/index.php?title=DS1307_RTC_Module_with_BAT_for_Raspberry_Pi_SKU:_EP-0059
[9]: https://archlinuxarm.org/wiki/Raspberry_Pi
[10]: https://gist.github.com/grubernd/aed721614b36aaa31fd97ef5ab1ec6be


