% Using the Raspberry Pi

# Using the Raspberry Pi

You should have been sent the following:

 * 2 × Raspberry Pi (RPi) 4B computers, each in a case, and each with
   a clock module already plugged in to pins 1-10. Open the case/box
   to check the clock module. If the clock module has come loose
   during travel, press it back onto pins 1-10 (see [here][1]).
 * 2 × MicroSD cards with operating systems pre-installed, removed for
   transit
 * 1 × MicroSD empty card (for burning an OS disk image at some later date)
   transit
 * 2 × USB 2/3 (male) to USB-C (male) cables
 * 1 × 120-240V to 5.5V power supply, with male USB-C plug
 * Mini-HDMI (male) to normal HDMI (male) cable

Gather/purchase the following materials:

 * 1 × Ethernet cable
 * Battery-based phone charger with USB output, as large a capacity as
   possible (20,000+ mAh)
   
Locate but do not yet purchase the following: 

 * PC keyboard with USB 2/3 plug
 * Video monitor (or television) with HDMI input

The PC keyboard and monitor may not be needed - they are for
troubleshooting only.

The second Raspberry Pi and MicroSD card are spares, and should be
kept somewhere safe and dry until needed.

## First usage

For the first usage:

 * Locate an internet router (see “Connecting to the internet”, below)
 * Contact Cam and begin a video call
 * Insert the MicroSD card into the slot on the bottom of the RPi
   (match MicroSD ‘MAN 1’ to RPi ‘Manombo 1’). If the unit is held
   upside down, the side of the card with writing on it should be
   _up_.
 * Start up the Raspberry Pi as in ‘Daily usage’ below.
 * Test to see if you can connect a laptop (or tablet or phone) to the
   RPi’s wifi, and see the main page, and log in to the
   database. 

There is no patient data in the database (for security during
transit), and it must now be loaded. So connect to the internet, as
below, and Cam will install the current patient data. At this point
Cam will also disable editing of the online database, **switching the
database ‘master copy’ to the RPi**.

## Daily usage

Start-up:

 * Switch the unit on by plugging in the USB cable.  **Note** if the
   mains electrical power might be interrupted, always run the
   Raspberry Pi either 1) using a UPS (Uninterrupted Power Supply;
   120-240 V) and the Raspberry Pi power supply, or 2) plugged into a
   battery phone charger, which in turn is plugged into a power
   supply. It is very important that the power to the Raspberry Pi is
   not interrupted.
 * Look through the vertical slot to the right of the MicroSD cad
   slow. There is a red power light that only indicates if the power
   is connected, and a green light that indicates CPU activity. On
   start-up, the green light will flicker for a few seconds, then be
   unlit for a few seconds, then begin a continuous double flash
   (flash-flash, pause, flash-flash, pause), like a heartbeat. This is
   the signal of normal operation.
 * Wait at least 1½ minutes before trying to connect.
 * On your own device (computer, tablet or phone), search for wifi
   signal. You should see SSID ‘klinikdb’: attempt to connect. There
   is no password needed. If you see your device reporting “waiting
   for IP...” or something similar, wait a little longer and try
   again. Once connected, your device will be given an IP in the range
   10.0.0.2 to 10.0.0.20.
 * Go to your browser and type the address `http://10.0.0.1/` into the
   address bar. You will be asked for a username and password, which
   you should have been given.
 * The static information pages should display.

Database and tools:

 * Click the “database” button, and you will be asked to log in to the
   database. This is _different_ username/password combination, which
   you should have been given.  The database should now be
   accessible. Depending on the ‘role’ of the user, you will see and
   be able to edit different tables.
 * To use the reporting tools and device management tools, you must
   log in again with your database username and password. Only ADMIN
   users may see these tools.

Shutdown:   

 * It is **vital** that the RPi is not unplugged without running a
   safe shutdown.  Data may be lost if the power is unexpectedly
   interrupted. To shut down, click on ‘Tools’ and locate the
   ‘Shutdown’ link. Click this and watch the indicator lights. After a
   few seconds the ‘heartbeat’ of the green light will change to
   steady blinking, then flickering, then go out. The red light will
   remain lit as long as power is connected. **When the green light is
   no longer lit, is is safe to disconnect the power**.
 * Note that you must be logged into the RPi website (above) to
   trigger a shutdown. Do not let anyone play with the device who does
   not know the username/password, as they will be unable to safely
   switch off the RPi if they happen to plug in the power.  You do not
   need to have ADMIN access to shut the RPi down; the ‘Shutdown’ link
   appears on the ‘Tools’ page for every user.

## Backing up

It is **vital** to backup the database often: ideally after every
major data entry session, and at a minimum once a week.  If the power
is interrupted, the RPi may fail.  This backup process creates an
encrypted backup with a timestamp in the file name.  These are safe to
store on any computer or flashdrive.  It is **strongly recommended**
that a copy of the backup is made at least once a week on a flash disk
which is stored (and hidden) at a different location from either the
RPi or the laptop which downloaded the backup. In this way if the
laptop or the RPi are damaged or stolen a recent backup will still
exist.  At least once every month a copy of the backup should be
emailed to Cam Webb.

The data can only (currently) be decrypted by Cam Webb and someone at
Health in Harmony. In the event of a loss of the main RPi data and a
switch to backup hardware, Cam will install the latest database backup
onto the new RPi.

Backup procedure:

 * Log in as a user (with ADMIN role) to the ‘Tools’ section
 * Click on the ‘Make backup file’ link. 
 * In the next page you will get a ‘success’ indication and a link for
   the backup file.
 * Click on the link, and download (save) the file to your own
   computer/phone. The name of the file will be something like
   `20210508-0727_manombo.sql.gz.asc`, where `20210508-0727` is the
   time of backup (in local timezone), e.g., 8 May 2021 and 7:27 AM.

## Connecting to the internet

In order to update software and manage the database, Cam will need
access to the RPi. Even though it is on the other side of the world, a
secure connection (SSH tunnel) can be made, if the connection is
initiated by the RPi user.  Before connecting, make an arrangement
with Cam. It will usually be helpful to also have a video call running
at the same time.

 * Locate a standard wifi router that is connected to the internet
   (usually by ADSL, maybe by cable or optical fiber), and which also
   has ethernet ports on the back.  Usually there is no MAC filtering
   set in the Router and all ethernet connections are accepted. If
   there _has_ been MAC security set, the RPi MAC address must be
   allowed via the router’s admin panel.
 * Connect the RPi to the router with an ethernet cable.
 * In the Tools section, click “Connect to network”. 
 * If the connection is established, a new status page will show
   “Success” and the IP number of the RPi’s ethernet port.
 * If the connection is not established, an error will show. Cam will
   attempt to troubleshoot the connection.

To disconnect: 

 * Click the “Disconnect” link. 
 * The ethernet cable is now safe to unplug.
 
[1]: https://wiki.52pi.com/index.php?title=DS1307_RTC_Module_with_BAT_for_Raspberry_Pi_SKU:_EP-0059
