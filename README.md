# Get-USB
Windows Forensics script to retrieve a list of USBs inserted on a local machine. 

Get-USB will parse the USBSTOR registry key located in the local machine registry hive and return the USB's name, device ID, Unique ID, the date first connected, and date last connected. 

# Notice
Get-USB has a dependency on [Get-RegistryKeyTimeStamp](https://github.com/proxb/PInvoke/blob/master/Get-RegistryKeyTimestamp.ps1) for the date first connected and date last connected properites to work. 
