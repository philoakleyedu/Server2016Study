ForEach ($Secret in $Secrets) {
                Backup-AzureKeyVaultSecret -VaultName PhilTest -Name $Secret.Name -OutputFile $BackupPath -force
            }