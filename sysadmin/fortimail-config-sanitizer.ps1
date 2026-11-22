#requires -Version 5.1
<#
.SYNOPSIS
  Creates a review-only sanitized text copy of a readable FortiMail CFG backup.
.DESCRIPTION
  Runs locally and never modifies the source. Removes credentials, PEM blocks,
  private-data encryption material, ALL serialized "execute create" records,
  and trailing REVISION_DATA / DLP encoded payloads found in FortiMail 7.6.x.

  The result is NOT a valid restore configuration. Safelist/blocklist entries
  stored as serialized records are intentionally omitted. This is a best-effort
  sanitizer, not a proof that no sensitive information remains.
.EXAMPLE
  .\Sanitize-FortiMailConfig-v2.ps1 -Path 'C:\IT\fortimail.cfg'
.EXAMPLE
  .\Sanitize-FortiMailConfig-v2.ps1 -Path 'C:\IT\fortimail.cfg' -OutputPath 'C:\IT\fortimail-for-review.txt'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceItem = Get-Item -LiteralPath $Path -ErrorAction Stop
if ($sourceItem.PSIsContainer) { throw 'The input must be a file.' }
$sourcePath = $sourceItem.FullName
if ($sourceItem.Length -eq 0 -or $sourceItem.Length -gt 50MB) {
    throw 'The input is empty or larger than 50 MB; verify this is a core CFG backup.'
}
if ($sourceItem.Extension -match '(?i)^\.(enc|zip|gz|tgz|tar|p12|pfx|p7b|p7c)$') {
    throw 'Encrypted/archive/certificate container files are not supported. Export a readable text CFG.'
}
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $sourceItem.DirectoryName ($sourceItem.BaseName + '.sanitized.txt')
}
$destination = [System.IO.Path]::GetFullPath(
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
)
if ([string]::Equals($sourcePath, $destination, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'Input and output must be different files.'
}
if (Test-Path -LiteralPath $destination) {
    throw 'Output file already exists. Choose a different OutputPath to prevent overwriting.'
}
if (-not (Test-Path -LiteralPath (Split-Path -Parent $destination) -PathType Container)) {
    throw 'Output directory does not exist.'
}

# Fail closed on binary/compressed/encrypted input.
[byte[]]$raw = [System.IO.File]::ReadAllBytes($sourcePath)
if ($raw.Length -ge 2 -and (
    ($raw[0] -eq 0x1f -and $raw[1] -eq 0x8b) -or
    ($raw[0] -eq 0x50 -and $raw[1] -eq 0x4b) -or
    ($raw[0] -eq 0xff -and $raw[1] -eq 0xfe) -or
    ($raw[0] -eq 0xfe -and $raw[1] -eq 0xff))) {
    throw 'Compressed or UTF-16 input detected; expected a UTF-8 FortiMail CFG text file.'
}
if ([System.Array]::IndexOf($raw, [byte]0) -ge 0) {
    throw 'Input contains NUL/binary data. No output created.'
}
$utf8 = [System.Text.UTF8Encoding]::new($false, $true)
try { $content = $utf8.GetString($raw) }
catch { throw 'Input is not valid UTF-8 text. No output created.' }
if ($content -match '^(?:Salted__|-----BEGIN PGP MESSAGE-----)') {
    throw 'Input appears encrypted. No output created.'
}
if ($content -notmatch '(?m)^\s*(?:config|edit|set)\s+') {
    throw 'No recognizable FortiMail configuration structure found.'
}

$counts = [ordered]@{
    PemBlocks              = 0
    SensitiveFields        = 0
    PrivateDataSections    = 0
    ContinuedSecretLines   = 0
    EmbeddedCredentials    = 0
    SerializedRecords      = 0
    SerializedRecordLines  = 0
    RevisionDataSections   = 0
    DlpDataSections        = 0
    EncodedPayloadLines    = 0
}

# Remove PEM certificates, keys and CSRs before any line-oriented processing.
$pemPattern = '-----BEGIN (?<kind>[A-Z0-9][A-Z0-9 -]*?)-----[\s\S]*?-----END \k<kind>-----'
$counts.PemBlocks = ([regex]::Matches($content, $pemPattern)).Count
$content = [regex]::Replace($content, $pemPattern, '[REDACTED_PEM_BLOCK]')
if ($content -match '-----\s*(?:BEGIN|END)\s+[A-Z0-9 -]+-----') {
    throw 'Unmatched PEM boundary detected. No output created.'
}

$sensitiveFieldPattern = '(?i)(?:pass(?:word|phrase|wd)?|pwd|psk|secret|token|credential|private[-_]?key|private[-_]?data|api[-_]?key|access[-_]?key|auth[-_]?key|bind[-_]?pass(?:word)?|community|oauth|client[-_]?secret|cert(?:ificate)?[-_]?data|csr|encryption[-_]?key|shared[-_]?key|smtp[-_]?auth|pkcs12|pfx|keytab|pem|key[-_]file|key[-_]material|^certificate$|^cert$|^key$)'
$setPattern = '(?i)^(?<indent>\s*)(?<command>set|append)\s+(?<field>[A-Za-z0-9_.-]+)(?:\s+(?<value>.*))?$'
$createPattern = '(?i)^\s*execute\s+create\s+(?<kind>[A-Za-z0-9_.-]+)\b(?<rest>.*)$'
$opaqueStartPattern = '(?i)^\s*####\s*FOLLOWING PART IS\s+(?<section>[A-Z0-9_ -]+?)\s*####\s*$'

$inputLines = [regex]::Split($content, '\r\n|\n|\r')
$outputLines = New-Object 'System.Collections.Generic.List[string]'

$privateDepth = 0
$skipQuoteChar = ''
$skipEncLines = $false
$inSerializedRecord = $false
$inOpaqueSection = ''
$opaqueEndPattern = ''

foreach ($line in $inputLines) {
    # A serialized record is opaque: never interpret its inner contents as
    # configuration directives or as another trailer section.
    if ($inSerializedRecord) {
        $counts.SerializedRecordLines++
        if ($line -match '^\s*"\s*$') { $inSerializedRecord = $false }
        continue
    }

    # Entire encoded trailing sections are excluded, including their payload.
    if ($inOpaqueSection -ne '') {
        if ($line -match $opaqueEndPattern) {
            $inOpaqueSection = ''
            $opaqueEndPattern = ''
        } else {
            $counts.EncodedPayloadLines++
        }
        continue
    }
    $sectionMatch = [regex]::Match($line, $opaqueStartPattern)
    if ($sectionMatch.Success) {
        $sectionName = $sectionMatch.Groups['section'].Value.Trim().ToUpperInvariant()
        switch ($sectionName) {
            'REVISION_DATA' {
                $inOpaqueSection = 'REVISION_DATA'
                $opaqueEndPattern = '(?i)^\s*####\s*REVISION_DATA\s+END\s*####\s*$'
                $counts.RevisionDataSections++
            }
            'DLP' {
                $inOpaqueSection = 'DLP'
                $opaqueEndPattern = '(?i)^\s*####\s*DLP\s+DATA\s+END\s*####\s*$'
                $counts.DlpDataSections++
            }
            default { throw ('Unknown opaque section "{0}". No output created.' -f $sectionName) }
        }
        $outputLines.Add('# [REDACTED_OPAQUE_SECTION: ' + $sectionName + ']')
        continue
    }

    # The "execute create" payloads can contain SQL, encrypted DKIM private
    # keys, salts, serialized safelists/blocklists, and long base64 blobs.
    # Remove ALL such records rather than trying to parse private content.
    # A multi-line record in a FortiMail backup ends in a line containing ".
    $createMatch = [regex]::Match($line, $createPattern)
    if ($createMatch.Success) {
        $kind = $createMatch.Groups['kind'].Value
        $rest = $createMatch.Groups['rest'].Value
        $counts.SerializedRecords++
        $counts.SerializedRecordLines++
        $outputLines.Add('# [REDACTED_SERIALIZED_RECORD: ' + $kind + ']')
        # Accept one-line quoted records; otherwise continue until the closing
        # quote on its own line. This deliberately avoids SQL's inner quotes.
        $openingQuoteIndex = $rest.IndexOf('"')
        if ($openingQuoteIndex -lt 0) {
            throw ('Unsupported execute create syntax for {0}; no output created.' -f $kind)
        }
        $quotedPart = $rest.Substring($openingQuoteIndex + 1)
        if (-not ($quotedPart -match '(?<!\\)"\s*$')) {
            $inSerializedRecord = $true
        }
        continue
    }

    if ($privateDepth -gt 0) {
        if ($line -match '(?i)^\s*config\s+') { $privateDepth++ }
        if ($line -match '(?i)^\s*end\s*$') {
            $privateDepth--
            if ($privateDepth -eq 0) { $outputLines.Add('end') }
        }
        continue
    }
    if ($line -match '(?i)^\s*config\s+system\s+encryption\s+private-data\s*$') {
        $outputLines.Add($line)
        $outputLines.Add('    # [REDACTED_PRIVATE_DATA_SECTION]')
        $privateDepth = 1
        $counts.PrivateDataSections++
        continue
    }

    # Remove any continuation lines from sensitive set/append values.
    if ($skipQuoteChar -ne '') {
        $quotePattern = '(?<!\\)' + [regex]::Escape($skipQuoteChar)
        if ([regex]::IsMatch($line, $quotePattern)) { $skipQuoteChar = '' }
        $counts.ContinuedSecretLines++
        continue
    }
    if ($skipEncLines) {
        if ($line -match '^\s*[A-Za-z0-9+/=_-]{16,}\s*$') {
            $counts.ContinuedSecretLines++
            continue
        }
        $skipEncLines = $false
    }

    $m = [regex]::Match($line, $setPattern)
    if ($m.Success -and [regex]::IsMatch($m.Groups['field'].Value, $sensitiveFieldPattern)) {
        $fieldName = $m.Groups['field'].Value
        $commandName = $m.Groups['command'].Value
        $indent = $m.Groups['indent'].Value
        $value = $m.Groups['value'].Value
        $outputLines.Add($indent + $commandName + ' ' + $fieldName + ' "[REDACTED]"')
        $counts.SensitiveFields++
        if ($value -match '^\s*(["''])') {
            $quote = $Matches[1]
            $quotePattern = '(?<!\\)' + [regex]::Escape($quote)
            if ((([regex]::Matches($value, $quotePattern)).Count % 2) -eq 1) {
                $skipQuoteChar = $quote
            }
        }
        if ($value -match '(?i)^\s*ENC\s*$') { $skipEncLines = $true }
        continue
    }

    # Scrub common inline credentials in comments, URLs, and header strings.
    $safeLine = $line
    $safeLine = [regex]::Replace($safeLine, '(?i)(\b(?:password|passphrase|passwd|pwd|token|api[-_]?key|client[-_]?secret|shared[-_]?secret|secret)\s*[=:]\s*)([^\s;,]+)', '${1}[REDACTED]')
    $safeLine = [regex]::Replace($safeLine, '(?i)\b(https?|smtps?|imaps?|ldaps?|ftp|sftp)://([^:/@\s]+):([^@\s/]+)@', '${1}://${2}:[REDACTED]@')
    $safeLine = [regex]::Replace($safeLine, '(?i)\bBearer\s+\S+', 'Bearer [REDACTED]')
    $safeLine = [regex]::Replace($safeLine, '\beyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\b', '[REDACTED_JWT]')
    if ($safeLine -cne $line) { $counts.EmbeddedCredentials++ }
    $outputLines.Add($safeLine)
}

# Fail closed on incomplete records or unsupported trailer formats.
if ($inSerializedRecord) { throw 'Unclosed execute create payload detected. No output created.' }
if ($inOpaqueSection -ne '') { throw 'Unclosed encoded section detected. No output created.' }
if ($privateDepth -ne 0 -or $skipQuoteChar -ne '') {
    throw 'Unclosed private-data/secret value detected. No output created.'
}

$result = [string]::Join("`r`n", $outputLines)
if ($result -match '-----\s*(?:BEGIN|END)\s+[A-Z0-9 -]+-----' -or
    $result -match '(?im)^\s*execute\s+create\s+' -or
    $result -match '(?im)^\s*####\s*(?:FOLLOWING PART IS|REVISION_DATA\s+END|DLP\s+DATA\s+END)' -or
    $result -match '(?i)AES_DECRYPT\s*\(|FROM_BASE64\s*\(|@priv_enc_key|serialization::archive') {
    throw 'Encoded or cryptographic payload remnants detected. No output created.'
}
foreach ($checkLine in $outputLines) {
    $check = [regex]::Match($checkLine, $setPattern)
    if ($check.Success -and [regex]::IsMatch($check.Groups['field'].Value, $sensitiveFieldPattern)) {
        if ($check.Groups['value'].Value -ne '"[REDACTED]"') {
            throw 'Unexpected sensitive field remains. No output created.'
        }
    }
    if ($checkLine -match '^\s*[A-Za-z0-9+/]{100,}={0,2}\s*$' -or
        $checkLine -match '(?i)^\s*(?:set|append)\s+[A-Za-z0-9_.-]+\s+["'']?(?:ENC\s+)?[A-Za-z0-9+/=_-]{120,}["'']?\s*$') {
        throw 'Unclassified long encoded value detected. No output created.'
    }
}

# Write only after all checks pass, using CreateNew to avoid overwrites.
$encoder = [System.Text.UTF8Encoding]::new($false)
$fileStream = [System.IO.FileStream]::new($destination, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
try {
    $writer = [System.IO.StreamWriter]::new($fileStream, $encoder)
    try { $writer.Write($result) }
    finally { $writer.Dispose() }
}
finally { $fileStream.Dispose() }

Write-Host 'Sanitized review copy created:' -ForegroundColor Green
Write-Host "  $destination"
Write-Host 'Redaction counts (not secret values):'
foreach ($name in $counts.Keys) { Write-Host ('  {0}: {1}' -f $name, $counts[$name]) }
Write-Warning 'BEST EFFORT only: inspect the output before sharing. IPs, domains, email addresses, usernames, and policy comments can remain.'
Write-Warning 'ALL serialized execute create records were removed, including their safelist/blocklist entries.'
Write-Warning 'REVIEW ONLY. Do not restore the sanitized file to FortiMail.'
