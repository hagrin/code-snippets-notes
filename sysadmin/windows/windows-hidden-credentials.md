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
When you run the /list switch, you will a bunch of entries, but the ones you will likely be interested in if you're having MSFT app issues are the 3 following -
```
Currently stored credentials:
Target: MicrosoftAccount:target=SSO_POP_User:user=test@gmail.com
Type: Generic
User: test@gmail.com
Saved for this logon only

Target: MicrosoftAccount:target=SSO_POP_Device
Type: Generic
User: 02gkmhqyeeqnsqgh
Saved for this logon only

Target: LegacyGeneric:target=MicrosoftAccount:user=test@gmail.com
Type: Generic
User: test@gmail.com
Local machine persistence
```
What does each of those credentials do?
- MicrosoftAccount:target=SSO_POP_User:user=test@gmail.com - Used for SSO (Single Sign-On) to Microsoft cloud services — it’s the online Microsoft Account authentication token
- MicrosoftAccount:target=SSO_POP_Device - This is a system-level credential that helps maintain the device’s trust relationship with Microsoft’s SSO infrastructure
- LegacyGeneric:target=MicrosoftAccount:user=test@gmail.com - Older-style stored credential (used by older APIs or legacy apps) that contains your Microsoft Account login token
