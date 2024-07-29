#! /bin/bash

echo "************************************************************"
echo "Automate Data Collection for FreeBSD Server Script v1.0"
echo "************************************************************"

# Read Current Directory
curr=${PWD}

# Create Directory :
mkdir $curr/FreeBSDIR

# Sesuaikan Directory
dir=$curr/FreeBSDIR

# Identifikasi Date :
date > $dir/0.DateTime.txt

# Identifikasi Versi Environment System :
uname -a > $dir/1.Versi_Kernel.txt
uname -or > $dir/2.Versi_OS.txt

# Identifikasi Aplikasi/Service
ps -aux > $dir/3.Daftar_Proses.txt
top -b -n 1 > $dir/4.Daftar_Running_App.txt
cat /root/.history > $dir/5.History.txt
ls /etc/cron* > $dir/6.Cron.txt
crontab -l > $dir/7.Crontab.txt
ls -al /var/cron/tabs/ > $dir/7-1.Crontab-$1.txt
bash -c 'for user in $(cut -f1 -d: /etc/passwd); do echo "Cron jobs for user: $user"; crontab -l -u $user; echo ""; done' > $dir/7-2.Crontab-$1.txt

# Identifikasi Jaring Komunikasi
netstat -- tulnp > $dir/8.Inbound.txt
netstat -- antup > $dir/9.Outbound.txt
netstat -- antup | grep "ESTA" > $dir/10.Established_Conn.txt
w > $dir/11.Connected_to_PC.txt
cat /etc/resolv.conf > $dir/12.DNS.txt
cat /etc/rc.conf > $dir/13.Hostname.txt
cat /etc/hosts > $dir/14.Hosts.txt

# Identifikasi User
cat /etc/passwd > $dir/15.Daftar_User.txt
cat /etc/passwd | grep "sh"> $dir/16.Daftar_User_Bash.txt
lastlogin > $dir/17.Lastlog.txt
last > $dir/18.Last.txt

# List Directory
ls -alrt -R /home > $dir/19.Homedir.txt
ls -alrt -R /usr/home > $dir/19.1.Homedir.txt
ls -alrt -R /var/www > $dir/20.VarWWWdir.txt
ls -alrt -R /usr/local/www > $dir/20.1.VarWWWdir.txt

# Searching Backdoor File
echo "Start Searching ..."
grep -REn "passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile|set_time_limit|base64__decode *\(" /home/ --exclude-dir $dir> $dir/21.Backdoor-Homedir.txt
grep -REn "passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile|set_time_limit|base64__decode *\(" /usr/home/ --exclude-dir $dir > $dir/21.1.Backdoor-Homedir.txt
grep -REn "passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile|set_time_limit|base64__decode *\(" /var/www/ --exclude-dir $dir > $dir/22.Backdoor-VarWWWdir.txt
grep -REn "passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|fclose|readfile|set_time_limit|base64__decode *\(" /usr/local/www/ --exclude-dir $dir > $dir/22.1.Backdoor-VarWWWdir.txt
echo "Finish Searching.\n"

# Searching others malicious activity
grep -Rinw /usr/home -e "slot" -e "gacor" -e "maxwin" -e "thailand" -e "sigmaslot" -e "zeus" -e "cuan" -e "777" > $dir/23.ListSlot-$1.txt
grep -Rinw /usr/local/www -e "slot" -e "gacor" -e "maxwin" -e "thailand" -e "sigmaslot" -e "zeus" -e "cuan" -e "777" > $dir/23.1.ListSlot-$1.txt
echo "Finish Searching.\n"

# Create Compressed File
tar -czf Collection.tar.gz FreeBSDIR
rm -rf FreeBSDIR

echo "************************************************************"
echo "Script Completed Succesfully, saved to ./Collection.tar.gz"
echo "************************************************************"
