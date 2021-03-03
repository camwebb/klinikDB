# Installation of KlinikDB on an Raspberry Pi

## Installing the OS

The LAMP stack behind KlinikDB could be installed on any OS. The
Raspberry Pi is usually installed with Noobs or Raspian, Debian
derivatives. However in the following Arch Linux is used, due to its
smaller size, and the greater familiarity of the developer with Arch.
The following details are for the installation of ArchLinuxARM on a
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
    power port), and a keyboard.
 5. Plug in a USB2 power supply to the RPi board.
 6. Login: `alarm`, password: `alarm`, then `su` to root, password
    `root` 
 7. Set up a wireless connection with `wifi-menu` 
 8. Finish up setup: `pacman-key --init` and `pacman-key --populate
    archlinuxarm`.
 9. Update system: `pacman -Syu` 

**Finish basic setup**. In the following, a prompt of `#` means ‘as
root’, and `$` means `as user (pi)`
    
    # pacman -S emacs
    # timedatectl set-timezone "Africa/Nairobi" # or yours
    # emacs /etc/locale.gen          # uncomment en_US.UTF-8 UTF-8
    # locale-gen
    # emacs /etc/locale.conf         # LANG=en_US.UTF-8
    # emacs /etc/hostname            # myhostname
    # emacs /etc/hosts
    # cat /etc/hosts
      127.0.0.1   localhost
      ::1         localhost
      127.0.1.1   myhostname.localdomain  myhostname
    # passwd   # set root password
    
Reboot: 

    # shutdown -r now 
 
Set up firewall: 

    # pacman -S ufw
    # systemctl start ufw
    # systemctl enable ufw
    # ufw allow SSH
    # ufw allow WWW
    # ufw enable
    # ufw logging off

Enable wifi access at startup with `# netctl enable wlan0-SSID`. If
you want a fixed IP on the LAN, rather than DHCP, edit
`/etc/netctl/wlano-SSID`.

SSHing in may give trouble with terminal commands. Add `TERM=vt100` to
`~/.bash_profile` for both user and root.

Now install some core packages:

    # pacman -S man emacs-nox rsync lynx mariadb git apache php7 php7-apache

Get klinikDB.

    $ cd ~
    $ git clone https://github.com/camwebb/klinikDB.git

## mariadb

    # mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    # systemctl start mysql
    # systemctl enable mysqld
    # mysql_secure_installation    # set a root password, all else default (Y)
    
    # mysql -u root -p
       MariaDB > CREATE USER 'pi'@'localhost' IDENTIFIED BY 'XXXX';
       MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'pi'@'localhost';
       MariaDB > FLUSH PRIVILEGES;
    
    $ mysql -u pi -p    # use password XXXX
      MariaDB > CREATE DATABASE klinikdb CHARSET 'utf8' COLLATE 'utf8_bin';
    $ mysql -u pi -p klinikdb < /home/alarm/klinikDB/sql/klinikDB.sql

# Web server

    # emacs /etc/httpd/conf/httpd.conf 
    
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

    # systemctl start httpd
    # systemctl enable httpd
    
USe `journalctl` to chech that it started.
    
    $ chmod a+rx ../alarm/

Test from inside:

    $ curl http://localhost/

should give the HTML contents of the kilinikDB homepage

Test from outside, in a browser, or:

    $ curl http://XXX.XXX.XXX.XXX/

should give the same.

## PHP

   # emacs /etc/php7/php.ini 

      < ;extension=mysqli.so
      ---
      > extension=mysqli.so
      
      < ;extension=pdo_mysql.so
      ---
      > extension=pdo_mysql.so
      
      < ;date.timezone =
      ---
      > date.timezone = Africa/Nairobi

    # systemctl restart httpd

## KlinikDB database

    $ cd klinikDB/web/db/
    $ cp conf_template.ini conf.ini
    $ emacs conf.ini

Set:

      host = "localhost"      
      user = "pi"     
      password = "XXXXXXXX"   
      name = "klinikdb"

Install xataface. Go to <https://github.com/shannah/xataface/> and get
the latest version.

    $ curl -LO https://github.com/shannah/xataface/archive/2.2.5.tar.gz
    $ tar xvzf 2.2.5.tar.gz 
    $ mv xataface-2.2.5/ xataface
    $ 2.2.5.tar.gz 

    $ mkdir templates_c
    $ chmod a+w templates_c

No try <http://localhost/db> and you should see the login screen.

## Power monitoring

Check for `raspberrypi_hwmon` module:

    # lsmod | grep raspberrypi_hwmon

    # pacman -S raspberrypi-firmware cronie
    # 



Since... batteries

The sysfs approach is legacy and probably being dropped from newer
kernels. The character device ABI, using /dev/gpiochip[0-9]+ (as
discussed by @joan), is the new way to access GPIOs. On Arch, the
gpio-utils package offers lsgpio, gpio-watch, gpio-hammer,
gpio-event-mon as easy CLI tools for interacting with GPIO character
devices.







## Issues

 * default passwords!
 * too much audit in journalctl. 
     * add audit=0 to bootargs in boot.tx (and remake with ./mkscr)
     * auditctl -e0
     

