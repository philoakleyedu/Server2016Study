# -- Set path to Output File
$JSONPath = "f:\temp\sqlserverstest.json"

# --- Delete file if it already exists
if (Test-Path $JSONPath) {
    Remove-Item $JSONPath
}

# --- Initialize JSON Array
"[" | Out-File $JSONPath

# --- Get all Subscription Details
$Subs = Get-AzureRmSubscription

# --- Loop Through the subscriptions
foreach ($Sub in $Subs) {
    Set-AzureRmContext -SubscriptionName $Sub.Name
    # --- Enumerate all SQL Servers for the Subscription
    $SQLServers = Get-AzureRMSqlServer

    # --- Break Down SQL Server Names for use in Hastable\JSON
    foreach ($Server in $SQLServers) {
        Switch -Wildcard ($Server.ServerName) {
            "cds-beta*" {
                $Prog = "CDS"             
                $AzureEnv = "BETA" 
            }
            "cds-dev*" {
                $Prog = "CDS" 
                $AzureEnv = "DEV"
            }
            "cds-sit*" {
                $Prog = "CDS"
                $AzureEnv = "SIT"
            }
            "cds-test*" {
                $Prog = "CDS"
                $AzureEnv = "TEST"
            }
            "das-demo*" {
                $Prog = "DAS"
                $AzureEnv = "DEMO"
            }
            "das-at*" {
                $Prog = "DAS"
                $AzureEnv = "AT"
            }
            "das-test*" {
                $Prog = "DAS"
                $AzureEnv = "TEST"
            }
            "das-test2*" {
                $Prog = "DAS"
                $AzureEnv = "TEST2"
            }
            default {
                $Prog = "Unknown"
                $AzureEnv = "Unknown"
            }
        }
        
        # ---Format to JSON 

        "{" + "`n" + '"Name":"' + $Server.ServerName + '",' + "`n" + `
            '"Subscription":"' + $Sub.Name + '",' + "`n" + `
            '"Program":"' + $Prog + '",' + "`n" + `
            '"Environment":"' + $AzureEnv + '"' + "`n" + `
            '},' `
            | Out-File $JSONPath -Append -Force
    }
   
}
# --- Remove final comma from output to close Array
$config = Get-Content -Path $JSONPath
$config[-1] = $config[-1] -replace '^(.*).$', "`$1$replaceCharacter"
$config | Set-Content -Path $JSONPath


# --- Enclose JSON Array And write to file n.b Encoding switch or else error reading back in 
"]" | Out-File $JSONPath -Encoding default -Append -Force


$Servers = Get-Content -Path $JSONPath | convertfrom-Json
$Servers | Format-Table 