using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Connect-AzAccount -Identity
Import-Module CosmosDB -UseWindowsPowerShell

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$acctName = (Get-AzCosmosDBAccount -ResourceGroupName cdca_rg | where Name -like cdca-tour-*).Name

$cosmosContext = New-CosmosDbContext -Account $acctName -Database CDCADB -ResourceGroup cdca_rg
$results = Get-CosmosDbDocument -Context $cosmosContext -CollectionId cdca-tour-schedule
$body = $results | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
