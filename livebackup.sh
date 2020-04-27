#!/bin/bash

# just a little tool when I want to backup a source file i'm working on but I'm too lazy to
# deal with github....i.e. for protyping w/o having to worry about VC.
# makes a copy of of the filename provided in
# to install make a directory inside the directory that contains the file you want a livebackup of
# and place this file in there.  for each file you want a live backup of run
# the script with the filename to seed the inital run and then run it in the background.
# just make sure you don't reboot and forget about it, to make reboot resliant install in in /etc/init.d
# md5 utility is set to work on a Mac's output, if you intend to run on another OS, adjust the name/cut delimiter

#interval betweeen each check in seconds
interval=30

[ "$1" == '' ] && echo "ERROR:  usage: ./livebackup {parent directory's filename to backup}" && exit
[ ! -f ../$1 ] && echo "ERROR:  $1 doesn't exist in parent directory" && exit

#if [ `ls ./$1* 2> /dev/null` ]; then
if [ `ls -t ./$1* | head -n1 2> /dev/null` ]; then
  prev_file=`ls -t ./$1* | head -n1`
  #next line will probalby work only on Mac OS, adjust if running on another *nix
  prev_md5=`md5 ./$prev_file |cut -d ' ' -f 4`
fi

while true ; do
  timestamp=`date "+%m-%d-%H-%M-%S"`
  new_backup="./$1.$timestamp"
  cp ../$1 ./$new_backup
  new_md5=`md5 ./$new_backup |cut -d ' ' -f 4`
  [ $prev_md5 =  $new_md5 ] && `rm -f ./$new_backup`
  sleep $interval
done
