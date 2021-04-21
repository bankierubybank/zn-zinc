New-Module -Name My-Utils-Module -ScriptBlock {

    function Get-COMPorts {
        <#
        .SYNOPSIS
        Return a list of COM ports connected to the specified computer.

        .DESCRIPTION
        Get-COMPorts is a function that returns a list of COM ports connected to the specified computer.

        .EXAMPLE
        Get-COMPorts

        .INPUTS
        NONE
        #>
        
        (Get-CimInstance -query "SELECT * FROM Win32_PnPEntity" | Where-Object { $_.Name -Match "COM\d+" }) | Select-Object -Property Name, Status, Present
    }

    function Get-WiFiHealth {
        <#
        .SYNOPSIS
        Return an information of WLAN connected.

        .DESCRIPTION
        Get-WiFiHealth is a wrapper of "netsh wlan show interfaces" command's output and return as PSCustomObject.

        .EXAMPLE
        Get-WiFiHealth

        .INPUTS
        NONE

        .OUTPUTS
        PSCustomObject

        .NOTES
        Author:  Chatchai Wongdetsakul
        #>

        #(netsh wlan show interfaces) -Match '^\s+Signal' -Replace '^\s+Signal\s+:\s+',''

        $output = (netsh wlan show interfaces) -Match '\s{2,}:\s'
        $wifiObj = [PSCustomObject]@{
            Name = ($output | Select-String -Pattern 'Name' -Raw).Split(":").Trim()[-1]
            Description = ($output | Select-String -Pattern 'Description' -Raw).Split(":").Trim()[-1]
            SSID = (($output | Select-String -Pattern 'SSID' -Raw) | Select-Object -First 1).Split(":").Trim()[-1]
            Radio = ($output | Select-String -Pattern 'Radio Type' -Raw).Split(":").Trim()[-1]
            Authentication = ($output | Select-String -Pattern 'Authentication' -Raw).Split(":").Trim()[-1]
            Cipher = ($output | Select-String -Pattern 'Cipher' -Raw).Split(":").Trim()[-1]
            Channel = ($output | Select-String -Pattern 'Channel' -Raw).Split(":").Trim()[-1]
            ReceiveRateMbps = ($output | Select-String -Pattern 'Receive rate' -Raw).Split(":").Trim()[-1]
            TransmitRateMbps = ($output | Select-String -Pattern 'Transmit rate' -Raw).Split(":").Trim()[-1]
            Signal = ($output | Select-String -Pattern 'Signal' -Raw).Split(":").Trim()[-1]
        }
        $wifiObj
    }

    Export-ModuleMember -Function Get-COMPorts, Get-WiFiHealth
}