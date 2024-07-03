from email.message import EmailMessage
from os import environ
from re import sub
from sys import argv

import smtplib

sender_mail = environ['SENDER_MAIL']
sender_pass = environ['SENDER_PASS']


# Creates an EmailMessage object with the recipient email, subject line, and body (as parameters)
def create_email(recipient, subject, body) -> EmailMessage:
    msg = EmailMessage()
    msg['To'] = recipient
    msg['Subject'] = subject
    msg['From'] = sender_mail
    msg.set_content(body)

    return msg


# Appends an image file to an existing EmailMessage object; it tries to open the requested file and append it to the
# email. Error handling for absent file in current directory and non-picture filetype is included
def add_image(msg: EmailMessage, file_name):
    try:
        with open(file_name, 'rb') as f:
            img_data = f.read()
            img_type = f.name.split('.')[-1]
            img_name = f.name

            msg.add_attachment(img_data, maintype='image', subtype=img_type, filename=img_name)

    except FileNotFoundError:
        print(f"The file you typed does not exist. : {img_name}\n")

    except TypeError:
        print("Invalid file format.\n")


# Establishes a session with Gmail's SMTP port, starts TLS encryption, logs into sender email account,
# and sends EmailMessage to server. Error handling for a failed log-in and nonexistent recipient email is included
def send_email(msg: EmailMessage):
    try:
        server = smtplib.SMTP(host='smtp.gmail.com', port=587)
        server.ehlo()
        server.starttls()
        server.ehlo()
        server.login(sender_mail, sender_pass)
        server.send_message(msg)
        server.quit()

    except smtplib.SMTPAuthenticationError:
        print("\nYou gave the incorrect login information for your gmail account.")
        quit()

    except smtplib.SMTPRecipientsRefused:
        print("\nThe email address which you wish to email does not exist.")
        quit()


# Retrieves the email recipient, converts "/s" into spaces for the subject line and email body, and iterates through
# all remaining arguments (representing file names) and calling add_image() on them
def main():
    mail_recipient = argv[1]
    mail_subject = sub(r"/s", " ", argv[2])
    mail_body = sub(r"/s", " ", argv[3])
    email = create_email(mail_recipient, mail_subject, mail_body)
    for i in range(4, len(argv)):
        add_image(email, argv[i])
    send_email(email)


if __name__ == "__main__":
    main()
