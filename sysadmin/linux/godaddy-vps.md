# Notes for Working with a GoDaddy VPS without cPanel / Plesk

Due to the fact that panel access almost doubles your VPS costs, here is a simple guide for working with your GoDaddy VPS without cPanel or Plesk. This will be with a web server slant since this is a guide for GoDaddy.

## Basic Steps

1) sudo apt update
2) sudo apt upgrade -y
3) sudo apt install apache2
4) sudo apt install mysql-server
5) sudo apt install php8.3 libapache2-mod-php8.3 (or whatever version number you are up to)
   - this is dual command, installs php and the Apache PHP module
6) sudo apt install php-mysql

Setup the websites that you want to setup.
7) Changed the DNS A record for a site
8) sudo mkdir -p /var/www/sitename/public_html
9) sudo chown -R $USER:$USER sitename/public_html

At this point, you have to configure the virtual hosts for all the sites.

18) sudo nano /etc/apache2/sites-available/domain.com.conf - this creates the config file for the domain.
19) In the file you will type -
``` 
       <VirtualHost ipaddress:80>
           ServerAdmin admin@domain.com
           ServerName domain.com
           ServerAlias www.domain.com
           DocumentRoot /var/www/domain.com/public_html
           ErrorLog ${APACHE_LOG_DIR}/domain.com_error.log
           CustomLog ${APACHE_LOG_DIR}/domain.com_access.log combined
        </VirtualHost>
```
21) sudo a2ensite domain.com.conf - this enables the site/virtual host
22) sudo systemctl restart apache2

At this point a basic HTML page will work, but PHP pages will throw an HTTP 500 error. This could be caused by a few issues; however, it is most likely caused by the fact the file permissions are wrong on your test file so you must sudo chmod your web files.

### Let's Encrypt

You're going to want to setup SSL certs for your sites and GoDaddy actually makes this incredibly difficult if you try searching for this on Google.

- sudo apt install certbot python3-certbot-apache -y
- sudo certbot --apache -d yoursite.com -d www.yoursite.com

After you successfully get an SSL cert from Let's Encrypt, you can verify where Let's Encrypt puts its own .conf file by running sudo apachectl -S to confirm all the .conf paths.

### FTP Server

While not advised to setup an FTP server, if you have to - 

At this point want to upload some files for testing but no FTP
- sudo apt install vsftpd
- sudo systemctl enable vsftpd
- sudo systemctl start vsftpd
- sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak - back up the configuration file
- sudo nano /etc/vsftpd.conf - make changes to the vsftpd configuration file as needed

By default vsftpd doens't support TLS and you need to fix this otherwise your password gets sent over cleartext.

- sudo mkdir -p /etc/ssl/private
- sudo openssl req -new -x509 -days 365 -nodes -out /etc/ssl/private/vsftpd.crt -keyout /etc/ssl/private/vsftpd.key
- sudo nano /etc/vsftpd.conf - make changes to the vsftpd configuration including the following - 
     - ssl_enable=YES
     - force_local_data_ssl=YES
     - force_local_logins_ssl=YES
     - rsa_cert_file=/etc/ssl/private/vsftpd.crt (this line exists, edit the existing)
     - rsa_private_key_file=/etc/ssl/private/vsftpd.key (this line also exists, edit the existing)
     - ssl_tlsv1=YES
     - ssl_sslv2=NO
     - ssl_sslv3=NO
     - ssl_ciphers=HIGH:!aNULL:MD5
     - pasv_enable=YES
     - pasv_min_port=40000
     - pasv_max_port=50000

All of this will get the FTP server working, but you will not get dropped into the right directory. You need to add one more thing - 
      - local_root=/var/www (or whatever directory you want)
