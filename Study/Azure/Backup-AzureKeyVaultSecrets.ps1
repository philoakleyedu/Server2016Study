<#
.SYNOPSIS
Backs up All KeyVault Secrets
.DESCRIPTION
Backs up All KeyVault Secrets to specified file account used to execute script must have relevant principles set
.PARAMETER BackupPath
The location of the Backup Files. 
.EXAMPLE
.\Backup-AzureKeyVaultSecrets.ps1 -Location c:\temp\Backup
#>

Param (
    [Parameter(Mandatory = $false)]
    [String]$BackupPath
)

# --- Import Azure Helpers
Import-Module (Resolve-Path -Path $PSScriptRoot\..\Modules\Azure.psm1).Path
Import-Module (Resolve-Path -Path $PSScriptRoot\..\Modules\Helpers.psm1).Path

If ($BackupPath -eq $null){
    $BackupPath = (get-location).Drive.Name + ":\temp\Backup"
}

$Subscriptions = Get-AzureRmSubscription
ForEach ($Subscription in $Subscriptions) {
    Set-AzureRmContext -SubscriptionName $Subscription.Name
    $ResourceGroups = Get-AzureRmResourceGroup   
    foreach ($ResourceGroup in $ResourceGroups) {
        $KeyVaults = Get-AzureRmResource -ResourceGroupName $ResourceGroup.ResourceGroupName -ResourceType Microsoft.KeyVault/vaults
        if ($KeyVaults -ne $null ) {
            $Secrets = Get-AzureKeyVaultSecret -VaultName $KeyVaults.Name 
            ForEach ($Secret in $Secrets) {
                $SecretName = $Secret.Name
                Backup-AzureKeyVaultSecret -VaultName $KeyVaults.Name -Name $Secret.Name -OutputFile $BackupPath$SecretName".blob" -force
                Write-Log -LogLevel Information -Message "Backed up "$BackupPath$SecretName".blob from " $KeyVaults.Name 
            }
        }
    }
}
