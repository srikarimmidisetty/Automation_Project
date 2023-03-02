#!/bin/bash
sudo apt update -y
sudo apt install apache2
sudo systemctl enable apache2
timestamp=$(date '+%d%m%Y-%H%M%S')
name='Srikar'
s3_bucket="upgrad-srikar"
sudo tar czf /tmp/${name}-httpd-logs-${timestamp}.tar.gz /var/log/apache2/*.log
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar.gz s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar.gz

if [ ! -f /var/www/html/inventory.html ] ;
then
        sudo touch /var/www/html/inventory.html
                sudo echo "Log Type     Time Created    Type    Size" > /var/www/html/inventory.html ;
fi

logtype=$(ls -lrth /tmp | grep -i "tar" | awk -F "-" '{print $8"-"$9}')
timecreated=$(ls -lrth /tmp | grep -i "tar" | awk -F "-" '{print $10"-"$11}' | sed 's/\.tar\.gz//')
filetype=$(ls -lrth /tmp | grep "tar" | awk -F "-" '{print $11}' | awk -F "." '{print $2}')
size=$(ls -lrth /tmp | grep -i "tar" | awk -F " " '{print $5}')

sudo echo "$logtype     $timecreated    $filetype       $size" >> /var/www/html/inventory.html

sudo rm -rf /tmp/*.tar.gz


if [ ! -f /etc/cron.d/automation ] ;
then
        sudo touch /etc/cron.d/automation
                sudo echo '* * * * *  root /root/Automation_Project/automation.sh' > /etc/cron.d/automation;
fi
