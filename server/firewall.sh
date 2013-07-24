set -e
set -x

firewall-cmd --permanent --zone=public --add-port  80/tcp
firewall-cmd --permanent --zone=public --add-port 443/tcp
firewall-cmd --permanent --zone=public --add-port 389/tcp
firewall-cmd --permanent --zone=public --add-port 636/tcp
firewall-cmd --permanent --zone=public --add-port  88/tcp
firewall-cmd --permanent --zone=public --add-port 464/tcp
firewall-cmd --permanent --zone=public --add-port  53/tcp
firewall-cmd --permanent --zone=public --add-port  88/udp
firewall-cmd --permanent --zone=public --add-port 464/udp
firewall-cmd --permanent --zone=public --add-port  53/udp
firewall-cmd --permanent --zone=public --add-port 123/udp
 
firewall-cmd --zone=public --add-port  80/tcp
firewall-cmd --zone=public --add-port 443/tcp
firewall-cmd --zone=public --add-port 389/tcp
firewall-cmd --zone=public --add-port 636/tcp
firewall-cmd --zone=public --add-port  88/tcp
firewall-cmd --zone=public --add-port 464/tcp
firewall-cmd --zone=public --add-port  53/tcp
firewall-cmd --zone=public --add-port  88/udp
firewall-cmd --zone=public --add-port 464/udp
firewall-cmd --zone=public --add-port  53/udp
firewall-cmd --zone=public --add-port 123/udp
