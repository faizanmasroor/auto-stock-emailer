<# Reads email_list.csv to create two lists: 1-list of all emails and 2--list of ticker portfolios for each email.
File paths for Python scripts are declared too. #>
$csvFilePath = Join-Path -Path $PSScriptRoot -ChildPath "email_list.csv"
$graphScript = Join-Path $PSScriptRoot "stock_grapher.py"
$emailScript = Join-Path $PSScriptRoot "email_sender.py"
$csvTable = Import-Csv -Path $csvFilePath
$emails = @($csvTable.email)
$tickerLists = @($csvTable.tickerlist)

<# For loop that iterates through each row in email_list.csv and does several tasks: get the email and ticker portfolio
($tickerList) of the current row, turn $tickerList into an array ($tickers), run stock_grapher.py with $tickers as
the arguments, store the graph file names and date (of the last trading day) given by the graph script's output,
and run email_sender.py with email attributes and graph file names as arguments. #>
for ($csvIdx = 0; $csvIdx -lt $csvTable.length; $csvIdx++) {
    <# Variables declaration for the current iteration, edge case handling (misc. spaces in tickerlist, empty
    entries) #>
    $email = $emails[$csvIdx]
    $tickerList = $tickerLists[$csvIdx] -replace '\s',''
    $tickers = $tickerList.split(",")
    $imageNames = @()
    Write-Output "<==========$email==========>`nRetrieving stock data for $($tickers.ToUpper() -join ", " ) ..."
    if ($email.length -eq 0) {
        Write-Output "No email entered at row $($csvIdx+1)."
        continue
    }
    if ($tickerList.length -eq 0) {
        Write-Output "No stocks entered for $email."
        continue
    }

    <# Executes Python script whose output is divided into tokens (file name, error, stock report date) by
    linebreaks, making $outputTokens iterable #>
    $outputTokens = & python $graphScript $tickers
    if ($outputTokens[-1] -eq "NoStockError") {
        Write-Output "FATAL: All entered stocks for $email ($($tickers.ToUpper() -join ", " )) are invalid."
        continue
    }
    <# Iterates through $outputTokens (except the last token, which is the stock report date) and appends all graph
    file names to $imageNames #>
    for ($tokenIdx = 0; $tokenIdx -lt $outputTokens.length-1; $tokenIdx++) {
        if ($outputTokens[$tokenIdx] -eq "InvalidStockError") {continue}
        $imageNames += $outputTokens[$tokenIdx]
    }
    $date = $outputTokens[-1]

    Write-Output "Data retrieval complete ..."
    Write-Output "`n# of Stocks Retrieved: $($imageNames.Count/2)/$($tickers.Count) [$(100*($imageNames.Count/2)/($tickers.Count))%]`n"

    Write-Output "Sending email ..."
    $subject = "Daily/sStock/sReport/sfor/s$date"
    $body = "Here/sare/sthe/slast/strading/sday's/sprice/sgraphs/sfor/syour/spreferred/sstocks."
    <# Sends the email with stock graphs attached #>
    Start-Process python -ArgumentList "$emailScript $email $subject $body $imageNames" -Wait -NoNewWindow
    Write-Output "Email successfully sent!`n"
}