#!/bin/bash
mkdir -p /tmp/ax3200
if [ "$2" == "step0" ]; then
  apt-get install curl
elif [ "$2" == "step1" ]; then
  rm /tmp/ax3200/*.img
  #curl -L http://cdn.awsde0-fusion.fds.api.mi-img.com/xiaoqiang/rom/rb01/miwifi_rb01_firmware_bbc77_1.0.71_INT.bin -o - | gzip > step1.imgz
  #curl -L https://downloads.openwrt.org/releases/22.03.2/targets/mediatek/mt7622/openwrt-22.03.2-mediatek-mt7622-xiaomi_redmi-router-ax6s-initramfs-recovery.itb -o - | gzip > step2.imgz
  #curl -L https://downloads.openwrt.org/releases/22.03.2/targets/mediatek/mt7622/openwrt-22.03.2-mediatek-mt7622-xiaomi_redmi-router-ax6s-squashfs-sysupgrade.bin -o - | gzip > step3.imgz
  systemctl stop NetworkManager
  systemctl stop systemd-resolved.service
  zcat step1.imgz > /tmp/ax3200/C0A81F64.img
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  ip address flush dev $1
  ip address add 192.168.31.100/24 dev $1
  echo =====
  echo "connect to serial:"
  echo "    J1"
  echo "[] [] [] []"
  echo "   RX G  TX"
  echo ""
  echo "power off, push reset, power on, release when led is fast blinking. shutdown when led is fast blinking blue"
  echo "DO THIS TWICE"
  echo "after, choose u-boot console in terminal"
  echo =====
  dnsmasq --no-daemon -i $1 --dhcp-range=192.168.31.1,192.168.31.99 --enable-tftp --tftp-root=/tmp/ax3200 --dhcp-boot=C0A81F64.img -p0 -K --log-dhcp --bootp-dynamic
elif [ "$2" == "step2" ]; then
  rm /tmp/ax3200/*.img
  zcat step2.imgz > /tmp/ax3200/C0A81F64.img
  echo =====
  echo "on terminal: tftpboot / bootm 0x4007ff28"
  echo =====
  dnsmasq --no-daemon -i $1 --dhcp-range=192.168.31.1,192.168.31.99 --enable-tftp --tftp-root=/tmp/ax3200 --dhcp-boot=C0A81F64.img -p0 -K --log-dhcp --bootp-dynamic
elif [ "$2" == "step3" ]; then
  zcat step3.imgz > /tmp/ax3200/sysupgrade.bin
  ip address flush dev $1
  ip address add 192.168.1.2/24 dev $1
  echo =====
  echo "wait 30s"
  echo "on terminal: cd /tmp; wget http://192.168.1.2:8000/sysupgrade.bin; sysupgrade sysupgrade.bin"
  echo =====
  cd /tmp/ax3200; python3 -m http.server
fi
