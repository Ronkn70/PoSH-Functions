Function Get-ComputerUptime{
Param(
[Parameter(Mandatory=$True)]
[String]$ComputerName
)
Get-CimInstance -ComputerName $Computer -ClassName win32_OperatingSystem | select csname, lastbootuptime
}