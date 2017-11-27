$JSONPath = "f:\temp\sqlserverstest.json"

if (Test-Path $JSONPath) {
    Remove-Item $JSONPath
}

"[" | Out-File $JSONPath
   
$Subs = Get-AzureRmSubscription

foreach ($Sub in $Subs) {
    
    Set-AzureRmContext -SubscriptionName $Sub.Name
    #$Sub.Name| Out-File $CSVPath -Append -Force
    $SQLServers = Get-AzureRMSqlServer

    foreach ($Server in $SQLServers) {
        #Get-AzureRmSqlServerFirewallRule -ResourceGroupName 
        #$Server.ResourceGroupName -ServerName
        Switch -Wildcard ($Server.ServerName) {
            "cds-beta*" {   $Prog = "CDS"             
                            $AzureEnv = "BETA" }
            "cds-dev*" {    $Prog = "CDS" 
                            $AzureEnv = "DEV"}
            "cds-sit*" {    $Prog = "CDS"
                            $AzureEnv = "SIT"}
            "cds-test*" {   $Prog = "CDS"
                            $AzureEnv = "TEST"}
            "das-demo*" {   $Prog = "DAS"
                            $AzureEnv = "DEMO"}
            "das-at*"   {   $Prog = "DAS"
                            $AzureEnv = "AT"}
            "das-test*" {   $Prog = "DAS"
                            $AzureEnv = "TEST"}
            "das-test2*" {  $Prog = "DAS"
                            $AzureEnv = "TEST2"}
            default {       $Prog = "Unknown"
                            $AzureEnv = "Unknown"}
        }
        
        # ---Format to JSON 

        "{" + "`n" + '"Name":"' + $Server.ServerName + '",' + "`n" + `
        '"Subscription":"' + $Sub.Name  + '",' + "`n" + `
        '"Program":"' + $Prog + '",' + "`n" + `
        '"Environment":"' + $AzureEnv + '"' + "`n" + `
        '},' `
        | Out-File $JSONPath -Append -Force
    }
   
}
    # --- Remove final character from file
    $config = Get-Content -Path $JSONPath
    $config[-1] = $config[-1] -replace '^(.*).$', "`$1$replaceCharacter"
    $config | Set-Content -Path $JSONPath



"]" | Out-File $JSONPath -Encoding default -Append -Force


$Servers = Get-Content -Path $JSONPath | convertfrom-Json
$Servers