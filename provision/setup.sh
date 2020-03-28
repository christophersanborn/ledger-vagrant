echo "Provisioning virtual machine..."

echo "Installing Utilities"
dpkg --add-architecture i386
apt-get update  > /dev/null
apt-get install git curl python-dev python-pip python-pil python-setuptools zlib1g-dev libjpeg-dev libudev-dev build-essential libusb-1.0-0-dev -y > /dev/null
apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 libc6-dev-i386 -y > /dev/null
apt-get install -y libffi-dev libssl-dev python-dev python3-dev python3-pip python3-pil > /dev/null
pip3 install --upgrade setuptools
pip3 install ledgerblue
echo "Installing BitShares-specific libs and dependencies"
pip3 install base58 asn1 enum34
pip3 install bitshares

echo "Setting up BOLOS environment"
mkdir /opt/bolos
cd /opt/bolos

echo "Installing custom compilers, can take a few minutes..."
wget -q https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q1-update/+download/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2
tar xjf gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2
ln -s /opt/bolos/gcc-arm-none-eabi-5_3-2016q1/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-gcc

wget -q http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
tar xvf clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz
mv clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-14.04 clang-arm-fropi
chmod 757 -R clang-arm-fropi/
chmod +x clang-arm-fropi/bin/clang
ln -s /opt/bolos/clang-arm-fropi/bin/clang /usr/bin/clang

echo "cloning sdk for nano s"
cd /opt/bolos/
git clone https://github.com/LedgerHQ/nanos-secure-sdk.git
cd nanos-secure-sdk/
git checkout tags/nanos-og-1601
cd /opt/bolos/

echo "finetuning rights for usb access"
# Add a udev-rule for each vender/product ID related to Ledger hardware:
# Access is granted to members of group plugdev.
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2581\", ATTRS{idProduct}==\"1b7c\", MODE=\"0660\", GROUP=\"plugdev\"" >/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2581\", ATTRS{idProduct}==\"2b7c\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2581\", ATTRS{idProduct}==\"3b7c\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2581\", ATTRS{idProduct}==\"4b7c\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2581\", ATTRS{idProduct}==\"1807\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2581\", ATTRS{idProduct}==\"1808\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2c97\", ATTRS{idProduct}==\"0000\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2c97\", ATTRS{idProduct}==\"0001\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2c97\", ATTRS{idProduct}==\"0004\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2c97\", ATTRS{idProduct}==\"1005\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2c97\", ATTRS{idProduct}==\"1011\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
echo "SUBSYSTEMS==\"usb\", ATTRS{idVendor}==\"2c97\", ATTRS{idProduct}==\"1015\", MODE=\"0660\", GROUP=\"plugdev\"" >>/etc/udev/rules.d/20-Ledger.rules
udevadm trigger
udevadm control --reload-rules
usermod -a -G plugdev vagrant

echo "Setting up bash profile"
echo "" >> /home/vagrant/.bashrc
echo "# Custom variables for Ledger Development" >> /home/vagrant/.bashrc
echo "export BOLOS_ENV=/opt/bolos" >> /home/vagrant/.bashrc
echo "export BOLOS_SDK=/opt/bolos/nanos-secure-sdk" >> /home/vagrant/.bashrc
echo "export ARM_HOME=/opt/bolos/gcc-arm-none-eabi-5_3-2016q1" >> /home/vagrant/.bashrc
echo "" >> /home/vagrant/.bashrc
echo "export PATH=\$PATH:\$ARM_HOME/bin" >> /home/vagrant/.bashrc
echo "export GCCPATH=/opt/bolos/gcc-arm-none-eabi-5_3-2016q1" >> /home/vagrant/.bashrc
echo "export CLANGPATH=/opt/bolos/clang-arm-fropi" >> /home/vagrant/.bashrc
