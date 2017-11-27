$CSVPath = "C:\temp\sqlserverstest.json"

if (Test-Path $CSVPath) {
    Remove-Item $CSVPath
}

"[" | Out-File $CSVPath
   
$Subs = Get-AzureRmSubscription

foreach ($Sub in $Subs) {
    
    Set-AzureRmContext -SubscriptionName $Sub.Name
    #$Sub.Name| Out-File $CSVPath -Append -Force
    $SQLServers = Get-AzureRMSqlServer

    foreach ($Server in $SQLServers) {
        #Get-AzureRmSqlServerFirewallRule -ResourceGroupName 
        #$Server.ResourceGroupName -ServerName 
        "{" + "`n" + '"Name":"' + $Server.ServerName + '",' + "`n" + '"Subscription":"' + $Sub.Name  + '"' + "`n" + '},' | Out-File $CSVPath -Append -Force
    }
   
}
    # --- Remove final character from file
    $config = Get-Content -Path $CSVPath
    $config[-1] = $config[-1] -replace '^(.*).$', "`$1$replaceCharacter"
    $config | Set-Content -Path $CSVPath


"]" | Out-File $CSVPath -Append -Force