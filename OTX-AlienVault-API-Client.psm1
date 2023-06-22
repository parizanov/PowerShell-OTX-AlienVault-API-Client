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

function Get-OTXSubPulses {
    <#
    .SYNOPSIS
    Retrieves all pulses from the AlienVault OTX (Open Threat Exchange) API for which you are subscribed to.

    .DESCRIPTION
    The Get-OTXSubPulses function retrievs all the pulses from the AlienVault OTX (Open Threat Exchange) API for which you are subscribed to.
    The function iterates through multiple pages of results, if there are such, until the specified maximum page limit is reached.
    Each page contains a list of pulses, and the function accumulates all the pulses in a response list.

    .PARAMETER MaxPage
    The maximum number of pages to retrieve. Each page contains a list of pulses.
    By default, the MaxPage parameter is set to 5.

    .EXAMPLE
    Get-OTXSubPulses -MaxPage 10
    Retrieves the pulses from the AlienVault OTX (Open Threat Exchange) API for which you are subscribed to, limiting the result to 10 pages.

    .INPUTS
    None. You cannot pipe input to this function.

    .OUTPUTS
    System.Object[]
    A list of pulses retrieved from AlienVault OTX API.

    .NOTES
    This function requires the Get-OTXApiKey function to retrieve the AlienVault OTX API key.
    Ensure that you have a valid API key configured before using this function.
    #>

    Param(
    [Parameter(Mandatory=$false)]
    [string] $MaxPage = 5
    )

    $apiKey = Get-OTXApiKey
    $headers = @{
        "X-OTX-API-KEY" = $apiKey
    }

    $apiUrl = "https://otx.alienvault.com/api/v1/pulses/subscribed?limit=10&page=1"
    $actualPages = [int]((Invoke-RestMethod -Uri $apiUrl -Headers $headers).count/10)
    if([int]$MaxPage -gt $actualPages){$MaxPage = $actualPages}
    $responseList = @()

    do {
        $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers
        $responseList += $response.results
        $apiUrl = $response.next
        [int]$percentage=([int]($apiUrl.Split('=')[2])/([int]$MaxPage+1))*100
        Write-Progress -Activity "Gathering OTX Pulses..." -Status " [ $percentage % ] " -PercentComplete $percentage
    } while ($response.next.Split('=')[2] -ne ([int]$MaxPage+1))

    Write-Output $responseList
}
