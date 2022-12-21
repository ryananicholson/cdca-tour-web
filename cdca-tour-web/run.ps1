using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

Connect-AzAccount -Identity
Import-Module CosmosDB -UseWindowsPowerShell

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$cosmosContext = New-CosmosDbContext -Account cdca-cosmos -Database CDCADB -ResourceGroup cdca-rg
$results = Get-CosmosDbDocument -Context $cosmosContext -CollectionId cdca-tour-schedule
$body = $results | Select-Object city

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
