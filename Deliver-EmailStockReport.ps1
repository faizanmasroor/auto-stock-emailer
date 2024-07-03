<# Reads email_list.csv to create two lists: 1-list of all emails and 2--list of ticker portfolios for each email.
File paths for Python scripts are declared too. #>
$csvFilePath = Join-Path -Path $PSScriptRoot -ChildPath "email_list.csv"
$graphScript = Join-Path $PSScriptRoot "stock_grapher.py"
$emailScript = Join-Path $PSScriptRoot "email_sender.py"
$csvTable = Import-Csv -Path $csvFilePath
$emails = @($csvTable.email)
$tickerLists = @($csvTable.tickerlist)

<# For loop that iterates through row in email_list.csv and does several tasks: get the email and ticker portfolio
($tickerList) of the current row, turn $tickerList into an array ($tickers), run stock_grapher.py with $tickers as
the arguments, store the graph file names and date (of the last trading day) by parsing the script's string output,
and run email_sender.py with email attributes and graph file names as arguments. #>
for ($index = 0; $index -lt $csvTable.length; $index++) {
    $email = $emails[$index]
    $tickerList = $tickerLists[$index]
    $tickers = $tickerList.split(",")

    Write-Output "<==========$email==========>`nRetrieving stock data for $($tickers.ToUpper() -join ", " ) ..."
    $output = & python $graphScript $tickers
    Write-Output "Data retrieval complete ..."
    $tokens = $output.split(":")
    if ($tokens[0] -eq "0") {
        # TODO: Add error handling in case of invalid ticker symbol (logic found in stock_grapher.py)
    }
    $imageNames = $tokens[0..($tokens.Count-2)]
    $date = $tokens[-1]
    Write-Output "Data parsing complete ..."
    Write-Output "Files saved: $($imageNames.Count)/$($tickers.Count*2) [$(100*$imageNames.Count/($tickers.Count*2))%]`n"

    Write-Output "Sending email ..."
    $subject = "Daily/sStock/sReport/sfor/s$date"
    $body = "Here/sare/sthe/slast/strading/sday's/sprice/sgraphs/sfor/syour/spreferred/sstocks."
    Start-Process python -ArgumentList "$emailScript $email $subject $body $imageNames" -Wait -NoNewWindow
    Write-Output "Email successfully sent!`n"
}