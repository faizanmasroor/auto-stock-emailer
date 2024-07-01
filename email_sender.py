from email.message import EmailMessage
from os import environ
from sys import argv

import imghdr
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
            img_type = imghdr.what(f.name)
            img_name = f.name

            msg.add_attachment(img_data, maintype='image', subtype=img_type, filename=img_name)

        print("Image successfully added.\n")

    except FileNotFoundError:
        print("The file you typed does not exist.\n")

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

        print("\nEmail has been sent.")

        server.quit()

    except smtplib.SMTPAuthenticationError:
        print("\nYou gave the incorrect login information for your gmail account.")
        quit()
    except smtplib.SMTPRecipientsRefused:
        print("\nThe email address which you wish to email does not exist.")
        quit()


# Prompts for recipient email, subject line, and body; all info is crafted into an EmailMessage. Prompts for image
# attachments and quits once "done" is entered. Calls send_email() on the EmailMessage
def main():
    mail_recipient = argv[1]
    mail_subject = "Subject"
    mail_body = "Body"

    email = create_email(mail_recipient, mail_subject, mail_body)

    print("""\nIf you wish to attach images, enter your files one by one.
Be sure to enter the relative location of each image (ex., "image.png", "../picture.jpg", "../data/graph.svg", etc.)
Once you are done, enter "done\".""")
    while True:
        img_name = input(">>> ")
        if img_name.lower() == 'done':
            break
        add_image(email, img_name)

    send_email(email)


if __name__ == "__main__":
    main()