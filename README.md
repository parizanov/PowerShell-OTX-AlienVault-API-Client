# OTX PowerShell Module
The OTX (Open Threat Exchange) PowerShell module provides a set of functions to interact with the AlienVault OTX (Open Threat Exchange) API. This module allows you to manage your OTX API key, retrieve pulses that you subscribed to, and access valuable threat intelligence information.

## Set-OTXApiKey
Sets the API key for the OTX module.

### Synopsis
Sets the API key for the OTX (Open Threat Exchange) module.

### Description
The Set-OTXApiKey function allows you to set and securely store the API key for the OTX module. The API key is used to authenticate and access the OTX AlienVault API.

### Parameters
None

### Example
```PowerShell
Set-OTXApiKey
```

Prompts the user to enter the API key and securely stores it locally.


## Get-OTXApiKey
Retrieves the API key for the OTX module.

### Synopsis
Retrieves the API key for the OTX (Open Threat Exchange) module.

### Description
The Get-OTXApiKey function retrieves the API key that has been securely stored using the Set-OTXApiKey function. This API key is required for authentication and accessing the OTX AlienVault API.

### Parameters
None

### Example
```PowerShell
Get-OTXApiKey
```

Retrieves the stored API key for the OTX module.


## Get-OTXSubPulses
Retrieves subscribed sub-pulses from the AlienVault OTX API.

### Synopsis
Retrieves all pulses from the AlienVault OTX (Open Threat Exchange) API for which you are subscribed to.

### Description
The Get-OTXSubPulses function retrievs all the pulses from the AlienVault OTX (Open Threat Exchange) API for which you are subscribed to.
    The function iterates through multiple pages of results, if there are such, until the specified maximum page limit is reached.
    Each page contains a list of pulses, and the function accumulates all the pulses in a response list.

### Parameters
MaxPage (Optional): The maximum number of pages to retrieve. Each page contains a list of pulses. By default, it is set to 5.

### Example
```PowerShell
Get-OTXSubPulses -MaxPage 10
```

## Installation
```PowerShell
PS C:\temp> Import-Module .\OTX-AlienVault-API-Client.psm1
```

- If you want to setup the module for long-term use
  - See [Microsoft documentation](https://docs.microsoft.com/en-us/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7).
  - Shortcut - just copy to its own folder in this location: $Env:ProgramFiles\WindowsPowerShell\Modules

## Prerequisites
- PowerShell version 5.1 or above.
- Valid AlienVault OTX API key. Use the Set-OTXApiKey function to set and store your API key securely.

## Getting Started
Before using the OTX PowerShell module, you need to set your API key using the Set-OTXApiKey function. Once the API key is set, you can use other functions to retrieve threat intelligence information.

For example:

```PowerShell
Set-OTXApiKey
```

```PowerShell
$pulses = Get-OTXSubPulses -MaxPage 5
```

Refer to the function descriptions for more details on how to use each function.

## License
This project is licensed under the MIT License.
