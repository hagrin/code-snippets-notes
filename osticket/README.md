# OSTicket Notes

## Installation Errors

You might run into a bunch of issues when installing OSTicket, but the most common one I found is that after filling out the installation form and hitting Submit you receive an HTTP 500 error.

### HTTP 500 Error

OSTicket does a really poor job of handling these errors and presenting the user with exactly what the error may be. You <strong>must</strong> check the logs to figure out what the error might be. Check the normal Apache logs, but also make sure to check your virtual host specific logs, if they exist, which will likely be located at /var/log/apache2/yoursite_error.log.

If you get this 500 error when trying to install, it very likely can be your mySQL connection where it will be either credentials or a login privilege issue. If you get a 500 error after trying to move sites or servers or folders, make sure you check file permissions and chmod additional permissions as necessary. Also, make sure you check the database connection string settings in include/ost-config.php. 

## OAuth2 Plugin

Here are some common issues you might face when trying to get the OAuth2 plugin working - 

### HTTP 403 Forbidden Error

If after you click the Sign In button for OAuth in OSTicket, if you receive a Forbidden 403 error, you must check your site error logs. You may find them in the typical Apache error logs, but if you don't see anything there check /var/log/apache2/yoursite_error.log. This is where I found many issues relating to HTTP errors I was receiving.

A common solution you will see in there is that "Permission denied" to the .htaccess file in the /api directory. Make sure that the file exists (and if not, create one) and that it has the correct permissions through chmod.

### HTTP 404 Error

There can be a few issues for this one.
1) First, just make sure that your Redirect URI in /scp/plugins.php matches the URI you have in your MSFT Application. Take special care of HTTP vs HTTPS.
2) More likely, the problem I found people ran into was that your site configuration file must have AllowOverrides set to All (it will likely be set to None). You will very likely set this in /etc/apache2/sites-available/yoursite.com.conf and it will look something like -

```
<VirtualHost YourSitesIP:443>
    ServerAdmin admin@yoursite.com
    ServerName yoursite.com
    ServerAlias www.yoursite.com
    DocumentRoot /var/www/yoursite.com/public_html

    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/yoursite.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/yoursite.com/privkey.pem
    ErrorLog ${APACHE_LOG_DIR}/yoursite_error.log
    CustomLog ${APACHE_LOG_DIR}/yoursite_access.log combined
    RewriteEngine on
    RewriteCond %{SERVER_NAME} =www.yoursite [OR]
    RewriteCond %{SERVER_NAME} =yoursite
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]

    <Directory /path/to/your/webapp>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

</VirtualHost>
```

### "Unable to Update Plugin Instance" Error

You may encounter this error if you have already created an OAuth2 instance and you need to change the path of your Redirect URI. Interestingly enough, you may encounter this error if you try to save a new Redirect URI path either through the frontend or even directly through the ost_config table in your database. On the frontend you will be met with a very long "Loading" AJAX popup and eventually you will get the error. If you try to make the change directly to the database, you will notice that the path will not change on the frontend. This is due to OSTicket's caching system where it will cache system settings to limit database calls. The easiest solution? Just make a new instance and make sure your you have the "secret value" from your Azure application or create a new one. However, if you're really against making a new instance, clear the contents of the /cache folder which should be storing cached system settings.
