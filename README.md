# Vagrant config file to create your LEDGER environment dev

Manages a minimalistic virtual machine in which we install `gcc-arm-none-eabi` and related compiler tools to support cross-compiling to the Ledger Nano S, and the BOLOS_SDK appropriate for building BOLOS apps for the Nano.  (BOLOS is the operating system that runs on the Ledger Nano devices.)

* Based on ubuntu/bionic64 (Ubuntu 18.4 "Bionic Beaver") base image. (Provides minimum Python3 version of 3.6.x.)
* Configures USB passthrough access to Ledger devices.
* Provides BOLOS SDK version in the 1.6.x series, to support development to the Ledger Nano S with 1.6.x Firmware installed.
* Provides 'ledgerblue' python library for managing Ledger Nano devices.
* Provides python libs to support development of BitShares apps.

## Installation
[VirtualBox](https://www.virtualbox.org/) is used to host the virtual machine and [Vagrant](https://www.vagrantup.com/) is used to create it / manage it.

- Install Vagrant and Virtualbox on your machine. For USB passthrough to work, you will also need to install the VirtualBox Extension Pack.
- Run the following:
```
$ git clone https://github.com/christophersanborn/ledger-vagrant.git
$ cd ledger-vagrant
$ vagrant up
```
This will take a few (possibly several) minutes to install.  After the virtual machine is up and running, you can connect to it with:
```
$ vagrant ssh
```
And you can shut down the machine (from the host maching) with:
```
$ vagrant halt
```

## Compile your ledger app
- Install your app under `apps/`.  For instance, from the host machine, do:
```
cd apps/
git clone https://github.com/LedgerHQ/blue-app-xrp
```
- Then connect to the machine with: `vagrant ssh`
- And build your app similar to this:
```
cd apps/blue-app-xrp
make clean
make
```
- Connect your ledger Nano S to your computer, and unlock PIN screen.
- Install the app on your ledger: `make load`
- Remove the app from the ledger: `make delete`

## Known issues
- USB port is locked out of the host machine, making tests rather tedious (needs to tear down `vagrant halt`) to test ledger on host machine
- on Ubuntu, if the dongle is not found in the vagrant box, be sure that your **host** user belongs to the vboxusers group `sudo usermod -aG vboxusers <username>` (see https://askubuntu.com/questions/25596/how-to-set-up-usb-for-virtualbox/25600#25600)
- if you have some issue involving wrong TARGET_ID, please either upgrade your nano S firmware to 1.6.x, or downgrade nano s secure sdk tag to nanos-1553, nanos-1421, or nanos-1314:
```
cd /opt/bolos/nanos-secure-sdk
sudo git checkout tags/nanos-1421
```
