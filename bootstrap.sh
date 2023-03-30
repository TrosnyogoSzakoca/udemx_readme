sudo su
sudo -i
apt-get update
chpasswd <<< "root:Alma1234"
apt-get install mc -y
apt-get install htop -y

#apt-get install -y apache2
