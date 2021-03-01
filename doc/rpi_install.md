# Installation of KlinikDB on an Raspberry Pi


# /boot/config.txt

Add the line:

    dtoverlay=gpio-shutdown

to the file. This will permit the shorting of pins 5 and 6 (the
defaults) to trigger a shutdown. The subsequent shorting of these pins
while the systm is shutdown (but connected to power) will trigger a
power-on event.

# mariadb

As root:

    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    systemctl start mysql
    systemctl enable mysqld
    mysql_secure_installation    # set a root password, all else default (Y)
    
     mysql -u root -p
       MariaDB > CREATE USER 'pi'@'localhost' IDENTIFIED BY 'XXXX';
       MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'pi'@'localhost';
       MariaDB > FLUSH PRIVILEGES;
    
As user: 
    mysql -u pi -p    # use password XXXX
      MariaDB > CREATE DATABASE klinikdb CHARSET 'utf8' COLLATE 'utf8_bin';
    mysql -u pi -p klinikdb < /path/to/klinikDB/sql/klinikDB.sql


# Web server

As root:

    # pacman -S apache git
    # ufw allow WWW
    # emacs /etc/httpd/conf/httpd.conf 
    
Make these 3 changes to /etc/httpd/conf/httpd.conf :

    LoadModule mpm_event_module modules/mod_mpm_event.so   ...to
      # LoadModule mpm_event_module modules/mod_mpm_event.so
    # LoadModule mpm_prefork_module modules/mod_mpm_prefork.so   ...to
      LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
    # LoadModule cgi_module modules/mod_cgi.so   ...to
      LoadModule cgi_module modules/mod_cgi.so
    DocumentRoot "/srv/http"   ...to 
      DocumentRoot "/home/alarm/klinikDB/web"
    <Directory "/srv/http">   ...to
      <Directory "/home/alarm/klinikDB/web"> 
    AllowOverride None   ...to
      AllowOverride All

As user:
    
    $ git clone https://github.com/camwebb/klinikDB.git
    $ chmod a+rx ../alarm/

