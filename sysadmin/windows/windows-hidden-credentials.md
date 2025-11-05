# Windows Hidden Credentials

Most people know about the Credential Manager and the credentials stored there, but there are hidden credentials that are stored which can sometimes cause issue during UPN / SAM name changes.

Open up Powershell and run - 
```
cmdkey /list
```
This will give you a list of hidden / stored credentials that you won't find in the Credential Manager. If you're having issues signing back into or staying signed into accounts after say a SAM or UPN change, you run the following powershell command -
```
cmdkey /delete:targetname
```
