param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    
    [Parameter(Mandatory = $true)]
    [string]$StorageAccountName,
    
    [Parameter(Mandatory = $true)]
    [string]$ContainerName,

    [Parameter(Mandatory=$true)]
    [string]$StorageAccountKey
)

try {
    # Authenticate with managed identity
    Connect-AzAccount -Identity -ErrorAction Stop

    # Select the specified subscription
    Select-AzSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop

    # Get all storage accounts in the specified subscription
    $storageAccounts = Get-AzStorageAccount

    # Loop through each storage account in the subscription
    $currentResult = foreach($storageAccount in $storageAccounts)
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

    # Get the storage context
    $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

    # Get the list of blobs in the container
    $blobs = Get-AzStorageBlob -Container $ContainerName -Context $storageContext

    # Check if there is a previous CSV file in the container
    $previousCsvBlob = $blobs | Where-Object { $_.Name -like "storagedetails_Sub_*.csv" } | Sort-Object LastModified | Select-Object -Last 1
    if ($previousCsvBlob) {
        # Download the previous CSV file
        $previousCsvFileName = $previousCsvBlob.Name
        Get-AzStorageBlobContent -Blob $previousCsvFileName -Container $ContainerName -Destination $previousCsvFileName -Context $storageContext

        # Import the previous CSV file
        $previousResult = Import-Csv -Path $previousCsvFileName

        # Compare the two versions and output the result
        $changes = $previousResult | Compare-Object -ReferenceObject $currentResult -Property RGName, Name, Location, Kind, Replication -PassThru
        if ($changes) {
            # Add date and timestamp to the CSV file name
            $dateTime = Get-Date -Format "yyyy_MM_dd_HHmm"
            $csvFileName = "storagedetails_Sub_$dateTime.csv"

            # Export results in a CSV file with the updated file name to the specified storage account and container
            $currentResult | Export-Csv -Path $csvFileName -Encoding UTF8 -NoTypeInformation

            # Upload the CSV file to the Azure Blob Container specified in the parameter section
            Set-AzStorageBlobContent -File $csvFileName -Container $ContainerName -Blob $csvFileName -Context $storageContext

            # Display a message if changes in Azure Storage Account(s) are found
            Write-Output "Changes in Azure Storage Account(s) found and details updated in the CSV file."
        } else {
            # Display a message if no changes are found
            Write-Output "No changes found in the Azure Storage Account(s)."
        }
    } else {
        # Add date and timestamp to the CSV file name
        $dateTime = Get-Date -Format "yyyy_MM_dd_HHmm"
        $csvFileName = "storagedetails_Sub_$dateTime.csv"

        # Export results in a CSV file with the updated file name to the specified storage account and container
        $currentResult | Export-Csv -Path $csvFileName -Encoding UTF8 -NoTypeInformation

        # Upload the CSV file to the Azure Blob Container specified in the parameter section
        Set-AzStorageBlobContent -File $csvFileName -Container $ContainerName -Blob $csvFileName -Context $storageContext        
        
        Write-Output "No previous CSV file found in the container. Created new CSV file with current Azure Storage Account details."
    }
} catch {
    Write-Error $_.Exception.Message
}
