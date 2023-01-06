#!/usr/bin/env bash
set -e

function check_wifi_kill () {
        echo $(rfkill list all | grep -A2 "dell-wifi" | grep "Hard" | cut -f2 -d":" | xargs)
}

if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
fi

rm -rf /opt/laptops
mkdir /opt/laptops

echo "main" > /opt/laptops/branch
cd /opt/laptops

git clone https://github.com/magfest/laptops.git repo

cp /opt/laptops/repo/ansible/roles/ubuntu/files/ansible-cron.sh /usr/local/bin/ansible-cron.sh
cd ~

dpkg --configure -a
chmod +x /usr/local/bin/ansible-cron.sh
bash ansible-cron.sh

while [[ "$(check_wifi_kill)" == "yes" ]]; do

        echo "Turn ON wifi switch on the right side"
        echo " -------> "
        sleep 5
done

for i in {1..15}; do
         echo "Laptop will reboot NOW ($i/15)- ctrl + c to abort."
        sleep 1
done

reboot now