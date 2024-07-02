<# Creates a list of all emails and a list of tickers belonging to each email, according to the email_list CSV
file, as well as script and file paths #>
$csvFilePath = Join-Path -Path $PSScriptRoot -ChildPath "email_list.csv"
$graphScript = Join-Path $PSScriptRoot "stock_grapher.py"
$emailScript = Join-Path $PSScriptRoot "email_sender.py"
$csvTable = Import-Csv -Path $csvFilePath
$emails = @($csvTable.email)
$tickerLists = @($csvTable.tickerlist)

<# For loop that iterates through each email and does several tasks: run stock_grapher.py for each stock in the
tickerlist column, store all the file names for the graphs in an array, and run email_sender.py with all the stock
graphs attached #>
for ($index = 0; $index -lt $csvTable.length; $index++) {
    $imageNames = @()
    $email = $emails[$index]
    $tickerList = $tickerLists[$index]

    <# Divides the tickerlist for an email into individual tickers before calling stock_grapher.py on each one and
    storing the graph file names in $CurrentImages #>
    $tickers = $tickerList.split(",")
    foreach ($ticker in $tickers) {
        $output = & python $graphScript $ticker
        $currentImages = $output.split(":")[0..1]
        $date = $output.split(":")[2]
        $imageNames += $currentImages
    }

    $subject = "Daily/sStock/sReport/sfor/s$date"
    $body = "Here/sare/sthe/slast/strading/sday's/sprice/sgraphs/sfor/syour/spreferred/sstocks."
    Start-Process python -ArgumentList "$emailScript $email $subject $body $imageNames" -Wait -NoNewWindow
}