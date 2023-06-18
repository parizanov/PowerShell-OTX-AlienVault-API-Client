function Set-OTXApiKey {
    <#
    .SYNOPSIS
    Sets the API key for the OTX (Open Threat Exchange) module.

    .DESCRIPTION
    The Set-OTXApiKey function allows you to set and securely store the API key for the OTX module. The API key is used to authenticate and access the OTX AlienVault API.

    .PARAMETER None
    This function does not accept any parameters.

    .EXAMPLE
    Set-OTXApiKey
    Prompts the user to enter the API key and securely stores it locally.

    .NOTES
    Ensure that you have write permissions to the user profile directory to store the API key securely.

    #>
    $apiKey = Read-Host "Enter your OTX API key"
    $secureApiKey = ConvertTo-SecureString $apiKey -AsPlainText -Force
    $apiKeyPath = "$env:USERPROFILE\otx_api_key.txt"

    if (Test-Path $apiKeyPath) {
        $overwriteConfirmation = Read-Host "The file exists. Do you want to overwrite it? (Yes[ y ]/No[ n ])"

        if ($overwriteConfirmation -eq "Yes" -or $overwriteConfirmation -eq "y") {
            $secureApiKey | ConvertFrom-SecureString | Out-File -FilePath $apiKeyPath -Force
            Write-Host "API key overwritten and stored securely at: $apiKeyPath" -ForegroundColor Green
        }
        elseif($overwriteConfirmation -eq "No" -or $overwriteConfirmation -eq "n") {
            Write-Host "API key not overwritten. Existing file remains at: $apiKeyPath" -ForegroundColor Yellow
        }
        else{Write-Host "Provide valid option - Yes[ y ] or No[ n ]" -ForegroundColor Red}
    }
    else {
        $secureApiKey | ConvertFrom-SecureString | Out-File -FilePath $apiKeyPath
        Write-Host "API key stored securely at: $apiKeyPath" -ForegroundColor Green
    }
}

function Get-OTXApiKey {
    <#
    .SYNOPSIS
    Retrieves the API key for the OTX (Open Threat Exchange) module.

    .DESCRIPTION
    The Get-OTXApiKey function retrieves the API key that has been securely stored using the Set-OTXApiKey function. This API key is required for authentication and accessing the OTX AlienVault API.

    .PARAMETER None
    This function does not accept any parameters.

    .EXAMPLE
    Get-OTXApiKey
    Retrieves the stored API key for the OTX module.

    .NOTES
    Ensure that you have previously set the API key using the Set-OTXApiKey function.

    #>
    $apiKeyPath = "$env:USERPROFILE\otx_api_key.txt"

    if (Test-Path $apiKeyPath) {
        $secureApiKey = Get-Content -Path $apiKeyPath | ConvertTo-SecureString
        $apiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureApiKey))

        return $apiKey
    }
    else {
        Write-Host "API key not found. Please run Set-OTXApiKey to store your API key."
        return $null
    }
}
