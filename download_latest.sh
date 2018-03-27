#!/bin/sh
if [ -z "$1" ];
then
	gmod='~/server1/garrysmod/gamemodes/yourrp'
else
	gmod=$1
fi
echo $gmod
git clone https://github.com/d4kir92/GMOD-YourRP-unstable.git tmp
rsync -a tmp/* $gmod
rm -rf tmp
