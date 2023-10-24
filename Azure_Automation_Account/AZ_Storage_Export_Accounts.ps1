param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,
    
    [Parameter(Mandatory = $true)]
    [string]$ContainerName
)

try {
    # Authenticate with managed identity
    Connect-AzAccount -Identity -ErrorAction Stop

    # Select the specified subscription
    Select-AzSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop

    # Get all storage accounts in the specified subscription
    $storageAccounts = Get-AzStorageAccount

    # Loop through each storage account in the subscription
    $result = foreach($storageAccount in $storageAccounts)
    {
        [PSCustomObject]@{
            SubscriptionID = $SubscriptionId
            RGName = $storageAccount.ResourceGroupName
            Name = $storageAccount.StorageAccountName
            Location = $storageAccount.Location
            Kind = $storageAccount.Kind
            Replication = $storageAccount.Sku.name
        }
    }

    # Add date and timestamp to the CSV file name
    $dateTime = Get-Date -Format "yyyy_MM_dd_HHmm"
    $csvFileName = "storagedetails_Sub_$dateTime.csv"

    # Export results in a CSV file with the updated file name to the specified storage account and container
    $result | Export-Csv -Path $csvFileName -Encoding UTF8 -NoTypeInformation

    # Get the storage context
    $storageAccountKey = "pD5PC/lKluOi37Bq1t/GRPVj9czuZQn7SWLnwDVINgyRogQACrpbrY9EtLxwEcIv7sUZPt7EDt9S+ASt68IJmQ=="
    $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $storageAccountKey

    # Upload the CSV file to the Azure Blob Container specified in the parameter section
    Set-AzStorageBlobContent -File $csvFileName -Container $ContainerName -Blob $csvFileName -Context $storageContext
}
catch {
    Write-Error $_.Exception.Message
}