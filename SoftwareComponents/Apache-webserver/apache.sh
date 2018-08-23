# Install Apache Web Server
yum -y update
yum install httpd

# Manage Apache HTTP Server
systemctl start httpd
systemctl enable httpd
# systemctl status httpd

# Configure firewalld to Allow Apache Traffic
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload

# Configure Name-based Virtual Host
cat <<EOF > /etc/httpd/conf.d/vhost.conf
NameVirtualHost *:80
<VirtualHost *:80>
ServerAdmin dimitri@automation.com
ServerName automation.com
ServerAlias www.automation.com
DocumentRoot /var/www/html/automation.com/
ErrorLog /var/log/httpd/automation.com/error.log
CustomLog /var/log/httpd/automation.com/access.log combined
</VirtualHost>
EOF

# Create directories for Virtual Host
mkdir -p /var/www/html/automation.com
mkdir -p /var/log/httpd/automation.com

# Create a dummy Index.html page for Virtual Host
echo "Welcome Automation gurus to my Apache Website" > /var/www/html/automation.com/index.html

# Restart Apache
systemctl restart httpd