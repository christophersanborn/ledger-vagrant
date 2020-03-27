# Vagrant config file to create your LEDGER environment dev

Manages a minimalistic virtual machine in which we install `gcc-arm-none-eabi` cross-compiler tools for compiling to the Nano and the BOLOS_SDK appropriate for building BOLOS apps for the Nano S.

## Installation
- Install Vagrant and Virtualbox on your machine
- Run the following
```
> git clone https://github.com/christophersanborn/ledger-vagrant.git
> cd ledger-vagrant
> vagrant up
```
This will take a few minutes to install

## Compile your ledger app
- install your app under `apps/` for instance:
```
cd apps/
git clone https://github.com/LedgerHQ/blue-app-xrp
```
- Connect to the machine `vagrant ssh`
- build your app
```
cd apps/blue-app-xrp
make clean
make
```
- connect your ledger Nano S to your computer
- install the app on your ledger: `make load`
- remove the app from the ledger: `make delete`

## Known issues
- USB port is locked out of the host machine, making tests rather tedious (needs to tear down `vagrant halt`) to test ledger on host machine
- on Ubuntu, if the dongle is not found in the vagrant box, be sure that your **host** user belongs to the vboxusers group `sudo usermod -aG vboxusers <username>` (see https://askubuntu.com/questions/25596/how-to-set-up-usb-for-virtualbox/25600#25600)
- if you have some issue involving wrong TARGET_ID, please either upgrade your nano S firmware to 1.5.x, or downgrade nano s secure sdk tag to nanos-1421 or nanos-1314:
```
cd /opt/bolos/nanos-secure-sdk
sudo git checkout tags/nanos-1421
```
