Kali Rolling on LXD
===================

Running build.sh in this resository will build a Kali Linux image for use with the LXD machine container engine.

LXD offers all of the benefits of running in a VM, without the assosicated performance penalty. 
LXD, in my biased opinion, also has a better security model out of the box than Docker or other containerisation engines.

The resulting image will be as light as possible, so you can apt-get install your ~~script kiddy~~ security auditing tools :P

Instructions
------------

Run `./build.sh`

The resulting image wll be tagged with an alias of 'kali', meaning you can then launch the image with:
`lxc launch kali name-of-container`

Author
------

Scripts are based on the Ubuntu image templates, and use the debootstrap template from Kali Linux.
Remaining glue belongs to nobody, and is totally copyleft (i.e. build.sh)
