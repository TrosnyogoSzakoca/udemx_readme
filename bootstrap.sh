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
sed -i 's/#Port 22/Port 2222:/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes:/g' /etc/ssh/sshd_config


apt-get install fail2ban -y
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

sed -i 's/# [sshd]/[sshd]:/g' /etc/fail2ban/jail.local
sed -i 's/# enabled = true/enabled = true:/g' /etc/fail2ban/jail.local

sed -i '/\[nginx-http-auth]/a enabled = true' /etc/fail2ban/jail.local

apt-get install nginx -y
sed -i 's/Welcome to nginx!/Hello UDEMX!/2' /var/www/html/index.nginx-debian.html

apt-get install mariadb-server -y
#mysql_secure_installation -y
#mysql
#create database UDEMX_DB;

apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt-cache policy docker-ce ##
apt install docker-ce
docker run hello-world

apt install git
git config --global user.email "udemx@udemx.eu"
git config --global user.name "udemx"

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5BA31D57EF5975CA # Jenkins key, nem értem

# 3735407
# after restart
- name: config fail2ban nginx-http-auth
      lineinfile:
        path: /etc/fail2ban/jail.local
        line: enabled = true
        insertafter: ^[nginx-http-auth]
        state: present
      become: true
