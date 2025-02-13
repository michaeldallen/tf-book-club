#!/bin/bash
yum update -y
yum install -y httpd
sed -i 's/Listen 80/Listen ${server_port}/' /etc/httpd/conf/httpd.conf
systemctl start httpd
systemctl enable httpd
echo "<h1>hello, tfbc ${cluster_name}</h1>" >  /var/www/html/index.html
echo "<p>db address: ${db_address}</p>" >> /var/www/html/index.html
echo "<p>db port: ${db_port}</p>"    >> /var/www/html/index.html
#EOF
