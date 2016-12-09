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
Terminal=true
EOF

sudo cat > LCD.desktop << EOF
[Desktop Entry]
Type=Application
Name=Reboot to LCD
Exec=/home/pi/LCD_show_v6_1_3/LCD35_v
Icon=/usr/share/icons/Moka/32x32/devices/input-tablet.png
Terminal=true
EOF

# Make them all executable
sudo chmod +x LCD.desktop HDMI.desktop keyboard.desktop

# We need to fix the Osoyoo Scripts a bit, now the only work locally
# We will add path to the beginning 
cd /home/pi/LCD_show_v6_1_3
echo $'echo \"Rebooting to LCD!\"\ncd /home/pi/LCD_show_v6_1_3' | cat - ./LCD35_v > temp && mv temp ./LCD35_v
echo $'echo \"Rebooting to HDMI!\"\ncd /home/pi/LCD_show_v6_1_3' | cat - ./LCD_hdmi > temp && mv temp ./LCD_hdmi

echo "All done, baby! Let's reboot and start the LCD"
./LCD35_v
