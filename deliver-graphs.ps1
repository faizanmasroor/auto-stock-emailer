<# Creates a list of all emails and a list of tickers belonging to each email, according to the email_list CSV
file, as well as script and file paths #>
$CSVFilePath = Join-Path -Path $PSScriptRoot -ChildPath "email_list.csv"
$GraphScript = Join-Path $PSScriptRoot "stock_grapher.py"
$EmailScript = Join-Path $PSScriptRoot "email_sender.py"
$CSVTable = Import-Csv -Path $CSVFilePath
$Emails = @($CSVTable.email)
$TickerLists = @($CSVTable.tickerlist)

<# For loop that iterates through each email and does several tasks: run stock_grapher.py for each stock in the
tickerlist column, store all the file names for the graphs in an array, and run email_sender.py with all the stock
graphs attached #>
for ($Index = 0; $Index -lt $CSVTable.length; $Index++) {
    $ImageNames = @()
    $Email = $Emails[$Index]
    $TickerList = $TickerLists[$Index]

    <# Divides the tickerlist for an email into individual tickers before calling stock_grapher.py on each one and
    storing the graph file names in $CurrentImages #>
    $Tickers = $TickerList.split(",")
    foreach ($Ticker in $Tickers) {
        $Output = & python $GraphScript $Ticker
        $CurrentImages = $Output.split(":")[0..1]
        $Date = $Output.split(":")[2]
        $ImageNames += $CurrentImages
    }

    $Subject = "Daily/sStock/sReport/sfor/s$Date"
    $Body = "Here/sare/sthe/slast/strading/sday's/sprice/sgraphs/sfor/syour/spreferred/sstocks."
    Start-Process python -ArgumentList "$EmailScript $Email $Subject $Body $ImageNames" -Wait -NoNewWindow
}