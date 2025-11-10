This will produce a CSV of all the mailboxes in your tenant and get you the mailbox usage / sizes in KBs/MBs/GBs.

From there you can Text-to-Columns using spaces as a delimiter so be able to better sort, filer, etc.

```
Connect-ExchangeOnline -UserPrincipalName yourusername@domain.com
Get-Mailbox -ResultSize Unlimited | Get-MailboxStatistics | Select DisplayName, TotalItemSize, ItemCount, LastLogonTime | Sort-Object TotalItemSize -Descending | Export-Csv "D:\WhateverFileName.csv" -NoTypeInformation
```
