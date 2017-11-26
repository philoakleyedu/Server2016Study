
Login-AzureRmAccount

$BackupPath = (get-location).Drive.Name + ":\Backup.blob'"
$Subscriptions = Get-AzureRmSubscription
ForEach ($Subscription in $Subscriptions) {
    Set-AzureRmContext -SubscriptionName $Subscription.Name
    $ResourceGroups = Get-AzureRmResourceGroup   
    foreach ($ResourceGroup in $ResourceGroups) {
        $KeyVaults = Get-AzureRmResource -ResourceGroupName $ResourceGroup.ResourceGroupName -ResourceType Microsoft.KeyVault/vaults
        if ($KeyVaults -ne $null ) {
            $Secrets = Get-AzureKeyVaultSecret -VaultName $KeyVaults.Name 
            ForEach ($Secret in $Secrets) {
                Backup-AzureKeyVaultSecret -VaultName $KeyVaults.Name -Name $Secret.Name -OutputFile $BackupPath
            }
        }
    }
}
