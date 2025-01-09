# Script to get all mailboxes and their inbox rules in Office 365 / OWA
# To check OWA rules through Powershell you need the ExchangeOnlineManagement module -
# 
# Run - 
# Install-Module -Name ExchangeOnlineManagement -RequiredVersion 3.7.0
# (You can get the version here - https://www.powershellgallery.com/packages/ExchangeOnlineManagement/3.7.0 )
# 
# You will then run the powershell command - 
# Connect-ExchangeOnline -UserPrincipalName admin@yourdomain.com (where you put in admin username)
# You will then see a pop up to authenticate + MFA if applicable
# 
# You might run into an execution error that says a psm1 is "not digitally signed".
# You can temporarily fix this by not forcing all scripts to be signed by running - 
# 
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# 
# You can then run whatever script you need to run (in this case script to iterate through mailboxes and pull all OWA rules and output to a text file)
# 
# If you see a rule that you want to investigate further, use the powershell command - 
# Get-InboxRule -Mailbox somemailbox@domain.com -Identity "therulename" | Format-List *


# You have to change two things in the code below - 
# The $outputFile path to the path of the file you want
# The Connect-ExchangeOnline -UserPrincipalName to the account of an admin or someone with the necessary rights


# Define output file path
$outputFile = "C:\somefilename.txt"

# Connect to Exchange Online
Write-Host "Connecting to Exchange Online..."
try {
    Connect-ExchangeOnline -UserPrincipalName "admin@domain.com"
    Write-Host "Connected to Exchange Online."
} catch {
    Write-Error "Failed to connect to Exchange Online. Please check your credentials."
    exit
}

# Get all mailboxes
Write-Host "Fetching all mailboxes..."
$mailboxes = Get-Mailbox -ResultSize Unlimited

# Initialize output file
Write-Output "Inbox Rules Report - Generated on $(Get-Date)" | Out-File -FilePath $outputFile

# Loop through each mailbox
foreach ($mailbox in $mailboxes) {
    $emailAddress = $mailbox.PrimarySmtpAddress
    Write-Host "Processing mailbox: $emailAddress"

    try {
        # Get inbox rules for the mailbox
        $inboxRules = Get-InboxRule -Mailbox $emailAddress

        if ($inboxRules) {
            # Export rules to the output file
            $rulesText = "Mailbox: $emailAddress`n" +
                         ($inboxRules | Out-String) +
                         "`n==============================`n"
            Add-Content -Path $outputFile -Value $rulesText
        } else {
            # No rules found
            Add-Content -Path $outputFile -Value "Mailbox: $emailAddress`nNo rules found.`n==============================`n"
        }
    } catch {
        Write-Error "Failed to retrieve inbox rules for mailbox: $emailAddress"
        Add-Content -Path $outputFile -Value "Mailbox: $emailAddress`nError retrieving rules: $_`n==============================`n"
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

Write-Host "Script execution completed. Results saved to $outputFile"
