# Automatic Stock Email Script

#### A PowerShell script that automates stock data retrieval, graphing, and emailing with Python and allows for easy configuration with a CSV file.

## Installation and Usage

#### 1. [Clone](https://docs.github.com/articles/cloning-a-repository) the repository
```powershell
git clone https://github.com/faizanmasroor/auto-stock-emailer.git
```
#### 2. Turn on [2-Step Verification](https://myaccount.google.com/signinoptions/twosv) for the Google account you will be using to send emails
#### 3. :warning: Generate an [app password](https://myaccount.google.com/apppasswords) for your Google account[^1] :warning:
#### 4. Type "Edit environment variables for your account" in the Windows search bar and open the Environment Variables window
#### 5. Create the "SENDER_MAIL" and "SENDER_PASS" user variables as shown
![image](https://github.com/faizanmasroor/email-sender/assets/107204129/4890c7f7-b9ec-4e83-982e-967e104eea64)
#### 6. Open _email_list.csv_ and ensure it is in the same directory as _Email-StockReports.ps1_
![image](https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/268635f7-cabf-4d88-8ab2-ebd7edc6205e)
#### 7. Edit _email_list.csv_ to your liking, with all users to email and their associated stocks, abiding by the format below
![image](https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/fad08c80-15b4-46a0-93bf-fdea611c9889)
#### 8. Create a folder called _Graphs_ to save the stock graphs
![image](https://github.com/faizanmasroor/auto-stock-emailer/assets/107204129/d36d8ce0-f64d-4498-8efc-d4ca0aa67f53)
#### 9. Run the file with PowerShell
```powershell
./Email-StockReports.ps1
```

## Required Dependencies

**WIP**
