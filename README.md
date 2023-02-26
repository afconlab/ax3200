- Install VMware Workstation 17 Player or VirtualBox
- Install [Ubuntu 22.04](https://www.osboxes.org/ubuntu/)
- Change Network Adapter settings to `Bridged`
```
cd /tmp
sudo su
wget https://github.com/fensoft/ax3200/archive/refs/heads/master.zip
unzip master.zip
cd ax3200-master
ip a
```
- Get the interface with your home network like 192.168.x.x (example: ens33)
```
./ax3200.sh ens33 step0
./ax3200.sh ens33 step1 (follow instructions)
./ax3200.sh ens33 step2 (follow instructions)
./ax3200.sh ens33 step3 (follow instructions)
```
