using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$storageAccount = Get-AzStorageAccount | Where-Object -Property StorageAccountName -like "cdcatour*"
$context = $storageAccount.Context
$table = Get-AzStorageTable -Context $context -Name cdcatourtable
$body = Get-AzTableRow -Table $table.CloudTable | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
