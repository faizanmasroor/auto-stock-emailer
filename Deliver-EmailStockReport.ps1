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
    $email = $emails[$csvIdx]
    $tickerList = $tickerLists[$csvIdx]
    $tickers = $tickerList.split(",")
    $imageNames = @()

    Write-Output "<==========$email==========>`nRetrieving stock data for $($tickers.ToUpper() -join ", " ) ..."
    $output = & python $graphScript $tickers

    if ($output[-1] -eq "NoStockError") {
        Write-Output "FATAL: All entered stocks ($($tickers.ToUpper() -join ", " )) are invalid."
        continue
    }

    <# Each "token" is an individual file name, error message, or the date of the stock reports (one per graph
    script exeuction) #>
    $tokens = $output.split(":")
    for ($tokenIdx = 0; $tokenIdx -lt $tokens.length-1; $tokenIdx++) {
        if ($tokens[$tokenIdx] -eq "InvalidStockError") {continue}  # stock_grapher.py catches invalid stocks
        $imageNames += $tokens[$tokenIdx]
    }
    $date = $tokens[-1]

    Write-Output "Data retrieval complete ..."
    Write-Output "`nStock Retrieval Success Rate: $($imageNames.Count/2)/$($tickers.Count) [$(100*($imageNames.Count/2)/($tickers.Count))%]`n"

    Write-Output "Sending email ..."
    $subject = "Daily/sStock/sReport/sfor/s$date"
    $body = "Here/sare/sthe/slast/strading/sday's/sprice/sgraphs/sfor/syour/spreferred/sstocks."
    Start-Process python -ArgumentList "$emailScript $email $subject $body $imageNames" -Wait -NoNewWindow
    Write-Output "Email successfully sent!`n"
}