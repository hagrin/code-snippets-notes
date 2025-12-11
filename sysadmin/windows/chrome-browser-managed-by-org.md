# "Your browser is managed by your organization"

If you have a home PC that isn't on a domain and doesn't have any MDM software on it, if you see that your browser is being managed by your organization, do the following - 

* Go to chrome://policy
* See what policies are actually being deployed
* You can then go on your Windows PC and open regedit
* Go to both HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome and HKEY_CURRENT_USER\SOFTWARE\Policies\Google\Chrome and remove whatever policies you found in the step above
