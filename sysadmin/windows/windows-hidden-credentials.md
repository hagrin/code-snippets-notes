# Windows Hidden Credentials

Most people know about the Credential Manager and the credentials stored there, but there are hidden credentials that are stored which can sometimes cause issue during UPN / SAM name changes.

Open up Powershell and run - 
```
cmdkey /list
```
