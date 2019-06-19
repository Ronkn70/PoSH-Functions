Function Get-ADComputerSearchByDescription{

    <#
    Paramaters
        
        User searches for the description we specify. In Trinet's case the description field is usually set w/ the Full Name of a user.
        
        Log paramater will set the logging the output to the windows temp file. Default value is false.
        
        Properties allows you to customize what you are looking to be returned.
    #>
    Param(
    [Parameter(Mandatory=$True)]
    [Array]$User,
    [Bool]$Log = $false,
    [Parameter(HelpMessage = 'Enter any properties you wish to have displayed')]
    [Array]$Properties = 'Description,Name,OperatingSystem,OperatingSystemVersion'
    )

    <#
    Splits the user input (if multiple were entered and seperated by the comma (,)

    Searches AD for the description specified in the user paramter.

    Outputs the data into the console.
    #>
    $Properties = $Properties.split(',')
    foreach($_ in ($User).Split(',')){
    $Computers = Get-ADComputer -Filter {description -like $_} -Properties $Properties
        if ($Computers){
            ForEach ($Computer in $Computers){
                ForEach ($Property in $Properties){
                    $Output += $Computer.$Property 
                    $Output += "|"
                    }
            $Output
            If ($Log -eq $True){ 
                $Output | Out-File -filepath $env:SystemRoot'\Temp\ADDescriptionSearch.txt' -Append
            }
            Clear-Variable Output
            }
        Remove-Variable Computer -ErrorAction SilentlyContinue
        }
        Else{
            $_ +"|Not Found In AD" 
            If($Log -eq $True){ 
                $_ +"|Not Found In AD" | Out-File -filepath $env:SystemRoot'\Temp\ADDescriptionSearch.txt' -Append
            }
        }
    }
}