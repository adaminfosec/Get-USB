function Get-USB {
    
<#
.SYNOPSIS
Retrieves a history of USB devices on the local computer from 
default registry path HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Enum\USBSTOR. 
.DESCRIPTION
Get-USB parses the USBSTOR registry to retrieve a list of USBs on the local computer.
By default the registry path used is "HKLM:\SYSTEM\ControlSet001\Enum\USBSTOR"
.PARAMETER Path
The registry path to USBSTOR. 
If not specified, the default value is "HKLM:\SYSTEM\ControlSet001\Enum\USBSTOR"
.EXAMPLE
Get-USB
.EXAMPLE
Get-USB -Path "HKLM:\SYSTEM\ControlSet001\Enum\USBSTOR"
.EXAMPLE
"HKLM:\SYSTEM\ControlSet001\Enum\USBSTOR" | Get-USB
#>
    Param(
        [Parameter(ValueFromPipeline=$True)]
        [string]$Path ='HKLM:\SYSTEM\ControlSet001\Enum\USBSTOR'
    )

    $deviceIDs = Get-ChildItem -Path $Path
    
    foreach ($deviceID in $deviceIDs) {
        
        $usbPath = Join-Path -Path $Path -ChildPath $deviceID.PSChildName
        $uniqueIDobj = Get-ChildItem -Path $usbPath
       
        $usbProperties = $uniqueIDobj | Get-ItemProperty
        
        $deviceIDtime = $deviceID | Get-RegistryKeyTimestamp
        $uniqueIDtime = $uniqueIDobj | Get-RegistryKeyTimestamp

        $props = @{'USBName'= $usbProperties.FriendlyName;
                   'DeviceID'= $deviceID.PSChildName;
                   'UniqueID'= $uniqueIDobj.PSChildName;
                   'FirstConnected'=$deviceIDtime.LastWriteTime
                   'LastConnected'=$uniqueIDtime.LastWriteTime}
        
        $obj = New-Object -TypeName PSObject -Property $props
        $obj.PSObject.TypeNames.Insert(0,'AdamInfoSec.USB.RegistryInfo')
        Write-Output $obj
    }
}