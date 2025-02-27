import datetime
import os
import sys

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import yfinance as yf

today = datetime.date.today()
now = datetime.datetime.now()
file_path = os.path.abspath(__file__)


# Retrieves a Pandas DataFrame with the financial history of a stock
def get_data(ticker: yf.Ticker, period, interval) -> pd.DataFrame:
    hist = ticker.history(period=period, interval=interval)

    # Creates additional columns from 'Timestamp' to measure time (month, day, year, etc.)
    hist['Timestamp'] = hist.index
    hist['Minute'] = hist.Timestamp.dt.minute
    hist['Hour'] = hist.Timestamp.dt.hour
    hist['DecimalHour'] = hist.Timestamp.dt.hour  # This column is updated via hour_decimalize()
    hist['Day'] = hist.Timestamp.dt.day
    hist['Month'] = hist.Timestamp.dt.month
    hist['Year'] = hist.Timestamp.dt.year
    return hist


# Removes all finance-y columns other than the "High" column
def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    df.drop(columns=["Open", "Low", "Close", "Volume", "Dividends", "Stock Splits"], inplace=True)
    return df


# Filters the DataFrame passed as the argument such that it either includes only the last trading day (time_length =
# "Day") or the entire month which the last trading day belongs (time_length = "Month")
def filter_data(df: pd.DataFrame, time_length) -> pd.DataFrame:
    idx = -1
    while df.iloc[idx]['Day'] == today.day:
        idx -= 1
    df = df[df[time_length] == df.iloc[idx][time_length]]
    df = df[df['Day'] != today.day]
    return df


if __name__ == "__main__":
    for i in range(1, len(sys.argv)):
        tk_in = sys.argv[i]
        tk = yf.Ticker(tk_in.upper())

        try:
            month_hist = get_data(tk, "3mo", "1d")
            day_hist = get_data(tk, "5d", "30m")

        # Occurs when a Ticker object with an invalid ticker symbol gets get_data() called (an invalid stock's DataFrame
        # will be missing some columns and throw this error)
        except AttributeError:
            print("InvalidStockError")
            continue

        month_hist = clean_data(month_hist)
        day_hist = clean_data(day_hist)

        month_hist = filter_data(month_hist, time_length='Month')
        day_hist = filter_data(day_hist, time_length='Day')

        # Modify the "DecimalHour" column to represent decimal values (8.5, 9.5, 10.5, etc.) in rows where "Minutes"
        # is 30
        day_hist['DecimalHour'] = np.where(day_hist['Minute'] == 30, day_hist['Hour'] + 0.5, day_hist['Hour'])

        last_trade_day = datetime.date(day_hist.iloc[0]['Year'], day_hist.iloc[0]['Month'], day_hist.iloc[0]['Day'])
        month_plot = sns.lineplot(x=month_hist.Day, y=month_hist.High)
        plt.title(f"{last_trade_day.strftime('%B %Y')} {tk_in.upper()} Stock Price")
        plt.xlim(0, 32)
        plt.ylabel('High (USD)')
        plt.grid()
        month_plot_filename = f"{tk_in.lower()}_{last_trade_day.strftime('%Y%b%d')}_mplot_{now.strftime('%Y%m%d')}.png"
        plt.savefig(file_path + "\\..\\Graphs\\" + month_plot_filename)
        plt.clf()

        day_plot = sns.lineplot(x=day_hist.DecimalHour, y=day_hist.High)
        plt.title(f"{last_trade_day.strftime('%B %d, %Y')}, {tk_in.upper()} Stock Price (Last Trading Day)")
        plt.xlim(9, 16)
        plt.xlabel('Hour')
        plt.ylabel('High (USD)')
        plt.grid()
        day_plot_filename = f"{tk_in.lower()}_{last_trade_day.strftime('%Y%b%d')}_dplot_{now.strftime('%Y%m%d')}.png"
        plt.savefig(file_path + "\\..\\Graphs\\" + day_plot_filename)
        plt.clf()

        # Prints the graph names and current date, separated by a colon for easy parsing for the PowerShell script
        print(month_plot_filename, day_plot_filename, sep='\n')

    try:
        print(f"{last_trade_day.strftime('%m/%d/%Y')}")  # Prints the date of the stock report(s) for PS script to use
    except NameError:  # Occurs when all stocks are invalid
        print("NoStockError")
