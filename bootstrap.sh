sudo su
sudo -i
apt-get update
chpasswd <<< "root:Alma1234"
apt-get install mc -y
apt-get install htop -y
apt-get install openjdk-11-jdk -y

useradd -m -d /opt/udemx udemx
chpasswd <<< "udemx:udemx"

apt-get install openssh-server -y
systemctl status ssh
nano /etc/ssh/sshd_confix
^\ 
#ssh debian@0.0.0.0

#apt-get install -y apache2