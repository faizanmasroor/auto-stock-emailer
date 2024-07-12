# Automatic Stock Email Script

#### A PowerShell script that automates stock data retrieval, graphing, and emailing with Python and allows for easy customization with a CSV file.

## Installation and Usage

#### 1. [Clone](https://docs.github.com/articles/cloning-a-repository) the repository
```powershell
git clone https://github.com/faizanmasroor/auto-stock-emailer.git
```
#### 2. Turn on [2-Step Verification](https://myaccount.google.com/signinoptions/twosv) for the Google account you will be using to send emails
#### 3. :warning: Generate an [app password](https://myaccount.google.com/apppasswords) for your Google account[^1] :warning:
#### 4. Type "Edit environment variables for your account" in the Windows search bar and open the _Environment Variables_ window
#### 5. Create the "SENDER_MAIL" and "SENDER_PASS" user variables as shown
![image](https://github.com/faizanmasroor/email-sender/assets/107204129/4890c7f7-b9ec-4e83-982e-967e104eea64)
#### 6. Open _email_list.csv_ and ensure it is in the same directory as _Email-StockReports.ps1_
![image](https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/268635f7-cabf-4d88-8ab2-ebd7edc6205e)
#### 7. Customize _email_list.csv_ as you like, add new emails by creating newlines, and add stocks to existing emails, all while making sure to follow the format below:
![image](https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/fad08c80-15b4-46a0-93bf-fdea611c9889)
#### 8. Create a folder called _Graphs_ to save the stock graphs
![image](https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/d36d8ce0-f64d-4498-8efc-d4ca0aa67f53)
#### 9. Run the file with PowerShell
```powershell
./Email-StockReports.ps1
```

## Required Dependencies[^2]

* Python 3.12.4
* matplotlib 3.8.4
* NumPy 2.0.0
* Pandas 2.2.2
* Seaborn 0.13.2
* yfinance 0.2.40 (if using conda, run: `conda install yfinance -c ranaroussi`)

## Video Demo
https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/6faa9de5-aabc-4945-b3c5-b0ae6807a8b1

## Goal
**Create a simple and customizable process—through a PowerShell script—to keep each person in an emailing list up to date about their stock portfolio by sending formatted emails containing line graphs, on a monthly and daily period, for their selected stocks**

[^1]: I would <b> HIGHLY </b> advise against using your primary Gmail account to run this script. Preferably, create an alt/throwaway Gmail account for automating your emails.
[^2]: These are the versions the program was tested with; running the usual pip/conda installation commands without specifying package versions or channels will likely not cause any dependency issues.
