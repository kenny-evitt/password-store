# Read the contents of the clipboard and output the data as a dictionary serialized as a base64 string.


Add-Type -AssemblyName System.Windows.Forms

$data = [System.Windows.Forms.Clipboard]::GetDataObject()

#$data.GetType()   # DataObject

$dataFormatDictionary = New-Object "System.Collections.Generic.Dictionary[string, byte[]]"

$data.GetFormats()   # DEBUG

foreach ($format in $data.GetFormats())
{
    [byte[]]$bytes = $data.GetData($format)
    $dataFormatDictionary.Add($format, $bytes)
}

$memoryStream = New-Object System.IO.MemoryStream
$binaryFormatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter

#$binaryFormatter.Serialize($memoryStream, $data)   # Fails with exception "Type 'System.Windows.Forms.DataObject' in Assembly 'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089' is not marked as serializable."
$binaryFormatter.Serialize($memoryStream, $dataFormatDictionary)

$dataDictionaryBase64String = [System.Convert]::ToBase64String($memoryStream.ToArray())
$memoryStream.Close()
$memoryStream.Dispose()
$dataDictionaryBase64String   # Return




# De-serialize a base64 string as a dictionary and write its data to the clipboard

[byte[]]$ds_bytes = [System.Convert]::FromBase64String($dataDictionaryBase64String)

$ds_memoryStream = New-Object System.IO.MemoryStream -ArgumentList @($ds_bytes, [int]0, $ds_bytes.Length)
$ds_memoryStream.Write($ds_bytes, 0, $ds_bytes.Length)   # TODO: Test whether this is extraneous?
$ds_memoryStream.Position = 0;
$ds_binaryFormatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
[System.Collections.Generic.Dictionary[string, byte[]]]$ds_dataFormatDictionary = $ds_binaryFormatter.Deserialize($ds_memoryStream)

$ds_data = New-Object System.Windows.Forms.DataObject

foreach ($format in $ds_dataFormatDictionary.Keys)
{
    [byte[]]$bytes = $ds_dataFormatDictionary[$format]
    $ds_data.SetData($format, [Object]$bytes)
}

[System.Windows.Forms.Clipboard]::SetDataObject($ds_data)

$ds_memoryStream.Close()
$ds_memoryStream.Dispose()