param(
    [Parameter(Mandatory=$true)]    
    [String]$id,
    [Parameter(Mandatory=$true)]    
    [String]$secret,
    [Parameter(Mandatory=$true)]    
    [String]$tenent,
    [Parameter(Mandatory=$true)]    
    [String]$sitename
)

$body = @{
    "grant_type" = "client_credentials"
    "client_secret" = "$secret"
    "client_id" = "$id"
    "resource" = "https://storage.azure.com/"
}

$response = Invoke-RestMethod -Method Post -Uri https://login.microsoftonline.com/$tenent/oauth2/token -Headers @{ "Content-Type" = "application/x-www-form-urlencoded" } -Body $body -Verbose

[XML]$xml = '<?xml version="1.0" encoding="utf-8"?><StorageServiceProperties><StaticWebsite><Enabled>true</Enabled><IndexDocument>index.html</IndexDocument><ErrorDocument404Path>404.html</ErrorDocument404Path></StaticWebsite></StorageServiceProperties>'

$headers = @{
    "Content-Type" = "application/xml"
    "x-ms-version" = "2018-03-28"
    "Authorization" = "Bearer $($response.access_token)"
}

Invoke-RestMethod -Uri https://$sitename.blob.core.windows.net/?restype=service"&"comp=properties -Method Put -Body $xml -Headers $headers -Verbose