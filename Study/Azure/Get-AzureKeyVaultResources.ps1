


#$CSVPath = (get-location).Drive.Name + ":\Azure Resources.csv"

Login-AzureRmAccount
$Subs = Get-AzureRmSubscription
$AllVaults = "Subscription Name : Resource Group : KeyVault "
ForEach ($Sub in $Subs) {
    Set-AzureRmContext -SubscriptionName $Sub.Name
    $ResourceGroups = Get-AzureRmResourceGroup   
    foreach ($ResourceGroup in $ResourceGroups) {
        $keyvaults = Get-AzureRmResource -ResourceGroupName $ResourceGroup.ResourceGroupName -ResourceType Microsoft.KeyVault/vaults
        if ($keyvaults -ne $null ) {
            $AllVaults += $Sub.Name + $ResourceGroup.ResourceGroupName + $keyvaults.Name
        }
    }
}

Write-Host $AllVaults