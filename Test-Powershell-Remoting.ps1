$ComputerName = <Name of Computer to check>
Invoke-Command -ComputerName $ComputerName -ScriptBlock {[System.Net.Dns]::GetHostName()}
 