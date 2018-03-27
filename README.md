# GMOD-YourRP-unstable
YourRP beta

download and put inside gamemodes folder
name this folder yourrp or change it to your category, but also rename the txt file! :D

script:
#!/bin/sh
git clone https://github.com/d4kir92/GMOD-YourRP-unstable.git tmp
rsync -a tmp/* ~/server1/garrysmod/gamemodes/yourrp/
rm -rf tmp
