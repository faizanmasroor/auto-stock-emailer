#    $FileName = 'test_script.py'
#    $Command = $PSScriptRoot+'\'+$FileName
#
#    Start-Process -FilePath $Command

$CSVFilePath = Join-Path -Path $PSScriptRoot -ChildPath "email_list.csv"
$CSVTable = Import-Csv -Path $CSVFilePath
$Emails = $CSVTable.email
$TickerLists = $CSVTable.tickers

for ($i = 0; $i -lt 3; $i++)
{
    $Email = $Emails[$i]
    $TickerList = $TickerLists[$i]
    $Tickers=$TickerList.split(",")
}