# OSTicket Notes

## Installation Errors

You might run into a bunch of issues when installing OSTicket, but the most common one I found is that after filling out the installation form and hitting Submit you receive an HTTP 500 error.

### HTTP 500 Error

OSTicket does a really poor job of handling these errors and presenting the user with exactly what the error may be. You <strong>must</strong> check the logs to figure out what the error might be. Check the normal Apache logs, but also make sure to check your virtual host specific logs, if they exist, which will likely be located at /var/log/apache2/yoursite_error.log. 

## OAuth2 Plugin

Here are some common issues you might face when trying to get the OAuth2 plugin working - 

### HTTP 403 Forbidden Error

If after you click the Sign In button for OAuth in OSTicket, if you receive a Forbidden 403 error, you must check your site error logs. You may find them in the typical Apache error logs, but if you don't see anything there check /var/log/apache2/yoursite_error.log. This is where I found many issues relating to HTTP errors I was receiving.

A common solution you will see in there is that "Permission denied" to the .htaccess file in the /api directory. Make sure that the file exists (and if not, create one) and that it has the correct permissions through chmod.

### HTTP 404 Error

There can be a few issues for this one.
1) First, just make sure that your Redirect URI in /scp/plugins.php matches the URI you have in your MSFT Application. Take special care of HTTP vs HTTPS.
2) More likely, the problem I found people ran into was that your site configuration file must have AllowOverrides set to All (it will likely be set to None). You will very likely set this in
