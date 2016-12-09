#!/bin/bash

echo "First things first: Update and Upgrade..."
sudo apt-get -y update
sudo apt-get -y dist-upgrade

echo "Downloading LCD driver..."
sudo wget http://en.kedei.net/raspberry/v6_1/LCD_show_v6_1_3.tar.gz
sudo tar xzvf LCD_show_v6_1_3.tar.gz
sudo rm LCD_show_v6_1_3.tar.gz

echo "Downloading some additional packages..."
sudo apt-get install -y matchbox-keyboard fortune cmatrix autoconf

echo "Installing Moka Icon Theme from Git..."
sudo mkdir git-repos
cd git-repos
git clone https://github.com/moka-project/moka-icon-theme.git

cd moka-icon-theme
bash autogen.sh
make
sudo make install

echo "Making desktop icons in /usr/share/applications..."
cd /usr/share/applications

sudo cat > keyboard.desktop << EOF
[Desktop Entry]
Type=Application
Name=Keyboard
Exec=matchbox-keyboard
Icon=/usr/share/icons/Moka/32x32/devices/input-keyboard.png
EOF

sudo cat > HDMI.desktop << EOF
[Desktop Entry]
Type=Application
Name=Reboot to HDMI
Exec=/home/pi/LCD_show_v6_1_3/LCD_hdmi
Icon=/usr/share/icons/Moka/32x32/devices/computer.png
EOF

sudo cat > LCD.desktop << EOF
[Desktop Entry]
Type=Application
Name=Reboot to LCD
Exec=/home/pi/LCD_show_v6_1_3/LCD35_v
Icon=/usr/share/icons/Moka/32x32/devices/input-tablet.png
EOF

# Make them all executable
sudo chmod +x LCD.desktop HDMI.desktop keyboard.desktop

echo "All done, baby!"
echo "Here's a fortune for your patience:"
echo ""
fortune