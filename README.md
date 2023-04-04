Miután telepítettem a kvm-et és a virtual managert saját linuxumra, sudo virt-manager paranccsal el is indítottam a virtual machine managert. Letöltöttem a debian 10-et és hozzáadtam a képfájlt a manageren belül. Elindítottam a telepítőt és hostname-nek a „debian” nevet választottam, majd a root password: „Alma1234”. Saját user, szintén „debian”, az ehhez tartozó jelszó pedig: „asd123”. A „Partition disks” résznél manuálisan szeretném beállítani a partíciókat, kiválasztom a virtual disket és csinálok egy új partíciót, aminek 15GB helyet adok. Primary, beginning, majd a mount pointot átírom (átkattintom) „/”-re. Majd ugyanezt megcsinálom csak a „/tmp”-re 475MB, ez már logical lesz, nem primary. Majd „/opt”-re 5GB, logical. Legvégül swap 1GB. Elindítom a telepítést, kész.

## Sudo telepítése:

„su -”, átlépünk a root felhasznlóba, „apt-get update”, „apt-get install sudo”, itt látjuk, hogy már a része volt, de a „debian” user nem része még a sudoers – nek (sudo ls), ezért hozzá kell adnunk. „usermod -aG sudo debian”. Restart.

## Midnight commander telepítése:

„sudo apt-get update”, hogy minden ok legyen

„sudo apt-get install mc -y”

„mc” elindul, örülünk

## htop telepítése:

„sudo apt install htop”

„htop” paranccsal el is indul most már

## java openjdk 8,11 telepítése:

„sudo apt install openjdk-8-jdk” parancs beírásakor láthatjuk, hogy nem tudja elérni ezt a packaget,

„sudo apt install openjdk-11-jdk” parancs viszont működik

8-as verzónál: le kell tölteni a jdk8-at egy oldalról pl. openlogic és úgy kibontani oda, ahol a többi java verzió van: „usr/lib/jvm”

„sudo update-alternatives –install /_usr_/bin/javac javac _usr/_lib/jvm/openlogic-openjdk-8u352-  b08-linux-x64/bin/javac 0”

majd: „sudo update-alternatives –set javac _usr_/lib/jvm/openlogic-openjdk-8u352-b08-linux-  x64/bin/javac”

így a javac át lett állítva 8-as verzióra a java pedig maradt 11-es

Itt sok mindent kipróbáltam, de remélem nem „szemeteltem” nagyon össze a gépet.
amit használhattam volna az a snapshot, ha jól tudom igy lehet "biztonsági mentést" késziteni és erre vissza lehet rollolni, ha valami baj van a virtuális géppel

## udemx user felvétele:

"sudo useradd -m -d /opt/udemx udemx"

aztán egy jelszó hozzá: "sudo passwd udemx"

váltás a udemx userre: "su - udemx"

## SSH elérés beállitása

ssh telepités: "sudo apt install openssh-server"

megnézzük a portot: "sudo systemctl status ssh"

default 22, debian@0.0.0.0 érhető el

csatlakozok hozzá: "ssh debian@0.0.0.0"

kéri a jelszót

belépünk a config file-ba: "sudo nano /etc/ssh/sshd_config"

itt a port részt kell átirni, amire szeretnénk 2222-re irtam át, itt bizonyosodjunk meg arról, hogy a "#"-t 

kitöröljük a port előtt, egy pár percig én is nézegettem, hogy miért nem váltott át

mentés és kilépés

## fail2ban install:
sudo apt-get install fail2ban

"nano fail2ban.local" editeljük a config fájlt

itt azt olvastam, hogy előtte a fail2ban config file-t ki kell másolni és úgy editelni egy .local file-ként, de amikor meg akartam nyitni, üres volt, aztán rájöttem, hogy nem éri el, mert rossz helyen keresem, hiszen a /etc/fail2ban/fail2ban.local helyre másoltam

**`[ssh]`** – by default, Fail2ban has no enabled jails

akkor csak ezt a file-t kell módositani

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

sudo nano /etc/fail2ban/jail.local

itt az sshd és a következő sor elejéről kell kitörölni a kettőskereszteket

az nginx-re rá kell keresni ugyanúgy a jail fileban és ott egy "enabled = true"-t rakni, hogy engedélyezve legyen

# Kiegészitő szolgáltatások

## Nginx
sudo apt install nginx

itt a port default 80

cd /var/www/html

itt pedig editelem a html-t "sudo nano"-val

Véletlen a title-t is átirtam "Hello UDEMX!"-re, de szerintem maradhat :)

## MariaDB

"sudo apt install mariadb-server" - el telepitem

itt a telepités útmutató, amit néztem a "sudo mysql_secure_installation" is ajánlja, hogy futtassuk, ez biztonságosabbá teszi az adatbázis kezelőnket

Itt kérdezi, hogy a root passwordot akarom e változtatni, erre azt mondtam, hogy nem, az összes többire y-al válaszoltam

sudo mysql

create database UDEMX_DB;

grant all privileges on UDEMX_DB.* TO 'UDEMX'@'localhost' identified by 'udemx';

belépek az adatbázis kezelőbe és létrehozok egy udemx_db adatbázist, majd csinálok hozzá egy udemx usert, aminek teljes hozzáférése van localhostban

## Docker

Itt jól jött ismét a digitalocean tutorialja, mivel ez nem egy egyszerű sudo apt install parancs és kész "dolog"

Az első paranccsal, ha jól értelmezem, telepitünk bizonyos packageket, amik engedélyezik, hogy https-en keresztül tudjak más packageket használni.

sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common

A következő pedig a cpg key-t adja hozzá a rendszerhez, hogy tudjuk használni a docker repót

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

Majd ezt a repót az apt forrásokhoz adom,

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

és végül updatelem az egészet, hogy frissüljön a hozzáadott apt-vel a rendszer

sudo apt update

Majd meg kell győződnünk arról, hogy biztosan a docker repóról akarjuk telepiteni a docker-t, az alap debian repó helyett

apt-cache policy docker-ce

végül pedig telepitjük a dockert

sudo apt install docker-ce

Legvégül pedig megnézem, hogy elindul-e az alap hello-world docker image

sudo docker run hello-world

itt nem találta elsőnek, de utána telepitette a :latest-et és utána el is indult

## Git
egyerű installal meg is vagyunk

sudo apt install git

Remélem jól értettem a configolást, itt a git config parancsot kell használni,

git config --global user.email "udemx@udemx.eu"

mellé még a user.name-et is átállitottam udemx-re

git config --global user.name "udemx"

ssh git:

itt az "ssh-keygen" parancsot kell használni és default helyet használva simán csak nyomunk egy entert, majd mégegyszer, mert passphrase-t sem állitunk be

ls ~/.ssh

listázzuk az ssh directory-t, ott lesz a publikus és az id key is

megnézzük, hogy az ssh-agent működik-e
eval "$(ssh-agent -s)"

igen, addoljuk az ssh-keyt

ssh-add ~/.ssh/id_rsa

majd pedig installálni kellene a git acc-hoz, de ezt nem igazán értettem hogyan kell

itt már elfáradtam, sajnos már szerda van, ideje feltölteni az eddigi munkát, ha lesz rá lehetőség, foglalkoznék még ezzel és biztos, hogy lesz kérdésem a pluszpontos feladatokhoz :D

# Dolgok feltöltése
winscp-t használtam, hogy a megadott credentialokkal belépjek a tárhelyemre

az xml fájlt a /etc/libvirt/qemu/debian10.xml néven/helyen meg is találtam

ezt fel is töltöttem a tárhelyre

To begin using iptables, you should first add the rules for allowed inbound traffic for the services you require. Iptables can track the state of the connection, use the command below to allow established connections.
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 2222 -j ACCEPT

sudo iptables -P INPUT DROP

1. script: 
mkdir scripts
cd scripts
nano db_dump.sh

#!/bin/bash
DIR=`date +%d-%m-%y`
DEST=~/db_backups/$DIR
mkdir $DEST

mysqldump -h mysql_hostname -u mysql_user -p"mysql_password" database_name > dbbackup.sql

chmod +x ~/scripts/db_dump.sh

crontab -e

0 2 * * * ~/scripts/db_dump.sh

2.

#!/bin/bash

ls -lt /var/log | head -4 | tail -3 >> mod-<DATE>.out

3.

(sudo) find /var/log/* -newermt „5 day ago” -ls >> last_five-<DATE>

4.
cat /proc/loadavg | tr „ „ „/n” | head -3 | tail -1

5.
sed -i ’s/<title>/Title:/g’ file.txt

jenkins:
https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-22-04
követése

ssh balu
balu Alma1234

docker install

docker compose most jön

jenkins dockerben:
admin
admin
jenkins url: localhost:8081/
