#!/bin/bash
args=$@
arg_count=$#
#echo "#=$#"
#echo "@=$@"
 func_help()
 {
 echo "Usage: info.sh [OPTIONS...]"
 echo "OPTIONS..."
 echo "-a --> Print all information"
 echo "-c --> Only CPU information (Frequency, core, cache(core, all), model, company)"
 echo "-r --> Only RAM information (Total, free, used, frequency)"
 echo "-d --> Only Disk information (total/used for all the disk connected)"
 echo "-e --> Only external device information(e.g. USB drive)"
 echo "-v --> Only video information(e.g. GPU model, memory, company, driver version)"
 echo "-m --> Motherboard (model, company, bios driver version)"
 echo "-o --> OS information(32/64 bit, distribution (ubuntu, mint, etc)"
 echo "-h --> help flag, usage example"
 echo " "
 echo "this tool gives you a method to get information about your computer (hardware and software)"
 echo " "
 }

 func_info_os()
 {
    echo "--------OS INFO--------"	 
    os_dist=`hostnamectl |grep 'Operating System:' | awk '{ for (i=3; i<=NF; i++) print $i }'`
    os_ker=`hostnamectl |grep 'Kernel:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
    os_arch=`hostnamectl |grep 'Architecture:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
    echo "Distribution type:" $os_dist
    echo "Kernel version:" $os_ker
    echo "Architecture:" $os_arch
 }

 func_info_motherboard()
 {
  echo "-------MOTHERBOARD INFO-------"
  s_manufacturer=`sudo dmidecode -s system-manufacturer`
  s_product_name=`sudo dmidecode -s system-product-name`
  bios_version=`sudo dmidecode -s bios-version`
  echo "Company:" $s_manufacturer
  echo "Product name:" $s_product_name
  echo "BIOS version:" $bios_version
 }

 func_info_video()
 {
  echo "------VIDEO CARD INFO-------"
  g_manufacturer=`glxinfo -B |grep 'Vendor:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
  g_version=`glxinfo -B |grep 'Version:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
  g_memory=`glxinfo -B |grep 'Video memory:' | awk '{ for (i=3; i<=NF; i++) print $i }'`
  g_device=`glxinfo -B |grep 'Device:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
  echo "Device:" $g_device
  echo "Company:" $g_manufacturer
  echo "Version:" $g_version
  echo "Video memory:" $g_memory
 }

 func_info_external()
 {
  echo "--------USB INFO---------"
  usb_count=`df -h | grep -c 'sd[b-z]'`
  echo "The number of USB devices :" $usb_count 
  echo "Devices_________Size__Used_Avail_Use%_Mounted on"
  df -h | grep 'sd[b-z]'
  if [ $? != 0 ]
  then
  echo "There are no plugged external devices (USB) in this computer."
  fi
 }

 func_info_disk()
 {
   echo "-------DISK INFO--------"
   lsblk -io  NAME,TYPE,FSUSE%,SIZE | grep -e 'NAME' -e 'sda'
 }

 func_info_ram()
 {
  echo "--------RAM INFO---------"
   total_mem=`free -h | grep 'Mem:' | awk '{print $2}'`
   used_mem=`free -h | grep 'Mem:' | awk '{print $3}'`
   free_mem=`free -h |grep 'Mem:' | awk '{print $4}'`
   frequency=`sudo dmidecode -t memory | grep -m 1 'Speed:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
   echo "Total:" $total_mem
   echo "Used:" $used_mem
   echo "Free:" $free_mem
   echo "Frequency:" $frequency

 }

 func_info_cpu()
 {
  echo "-------CPU INFO----------"
  cpu_arch=`lscpu |grep 'Architecture:' | awk '{ for (i=2; i<=NF; i++) print $i }'`
  cpu_core=`lscpu |grep 'CPU(s):' | awk '{ for (i=2; i<=NF; i++) print $i }'`
  cpu_model=`lscpu |grep 'Model name:' | awk '{ for (i=3; i<=NF; i++) print $i }'`
  cpu_speed=`lscpu |grep 'CPU MHz:' | awk '{ for (i=3; i<=NF; i++) print $i }'`
  cpu_op=`lscpu |grep 'CPU op-mode(s):' | awk '{ for (i=3; i<=NF; i++) print $i }'`
  echo "Architecture:" $cpu_arch
  echo "CPU Core:" $cpu_core
  echo "Model name:" $cpu_model
  echo "CPU Speed:" $cpu_speed
  echo "CPU op-mode(s):" $cpu_op
 }

function main
{
  if [ $arg_count == 0 ]
  then
  echo "Error: something is wrong, use -h option for help. (./info -h)"
  exit 1
  fi
  for i in $args  
  do  
    case $i in
      -h)
     func_help
     ;;
      -o)
     func_info_os
     ;;
      -m)
     func_info_motherboard
     ;;
      -v)
     func_info_video
     ;;
      -e)
     func_info_external
     ;;
      -d)
     func_info_disk
     ;;
      -r)
     func_info_ram
     ;;
      -c)
     func_info_cpu
     ;;
      -a)
     func_info_cpu
     func_info_ram
     func_info_disk
     func_info_external
     func_info_video
     func_info_motherboard
     func_info_os
     ;;  

       *)
     echo "Error: something is wrong, use -h option for help. (./info -h)"
     exit 2
    ;;
  esac 
 done
  exit 0
}
main
