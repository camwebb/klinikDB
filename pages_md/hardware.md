% Hardware

# Hardware

## Battery

I tested a smallish power pack (5.2 Ah, 5 V, max 2.1 A), which was
also rated at 18.7 Wh (though 5.2 @ 5V = 26 Wh?) and got more than 4.5
hours of use with a headless Raspberry Pi 4B. The
[specifications](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/specifications/)
of the RPi 4B say a 2.5A supply will be sufficient with downstream USB
draw of <0.5 A. At 2 A, a 5.2 Ah supply should only give ~2.5 hours,
so it seems a headless setup is drawing far less that 2 A. In fact,
[this site](https://raspi.tv/2019/how-much-power-does-the-pi4b-use-power-measurements)
indicates that the headless may draw as little as 0.6 A, giving a
battery time of up to 8 hours on a 5.2 Ah power pack. A larger 17.7 Ah
power pack may thus give over 25 hours of charge.

## Shutdown

_It is very important not to suddenly disconnect the RPi from a power
supply. The operating system needs to cleanly shutdown, and a sudden
loss of power may corrupt the files system._

During usual operation...

If for some reason the web interface is not available or not
responsive, a forced but safe shutdown may be initiated in this way:

 * Connect push-on wires to pins 5 and 6 of the GPIO (the General
   Purpose In/Out pins on the side of the RPi). These are the pair of
   pins third from the end farthest from the USB ports.
 * Connect the loose ends of the wires, so as to create a ‘short’, or
   closed sircuit.
 * The shutdown process will begin. Watch the green activity light; it
   will flicker for 5-10 seconds and then go dark (the red power light
   will continue to be lit). At this time the system has shut down and
   it is safe to disconnect the power.
 * Note: in a pinch, a penknife blade or screwdriver can be used to
   short these two pins.

