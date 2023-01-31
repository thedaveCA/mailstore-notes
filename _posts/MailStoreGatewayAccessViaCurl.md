---
title: 2023-00-00-MailStoreGatewayAccessViaCurl
categories: MailStoreGateway
tags: tips
published: false
---
MailStore Gateway has a POP3 server as part of the proxy functionality, it is possible access messages directly using curl if you have a need to inspect of the messages in a decrypted state. 

We first need to get the message number, then we can retrieve the message, so for example, one of the following:

$ curl --ssl-reqd --insecure pop3://msgw.example.com/ -u "mbx-2a20342e96294505a35eb5c8364eb67c"
1 91471

$ curl --ssl-reqd --insecure --request UIDL pop3://msgw.example.com/ -u "mbx-2a20342e96294505a35eb5c8364eb67c"
1 f558587b-b6d6-490d-b21e-eaf02172131a

In both cases above, I have 1 message in the mailbox, the size is 91471 bytes and name is f558587b-b6d6-490d-b21e-eaf02172131a (technically this is the UIDL in the POP3 protocol, but MailStore Gateway generates UIDLs using file names).

Once you have the message number, you can download it by adding the message number to the URI:
$ curl --ssl-reqd --insecure pop3://msgw.example.com/1 -u "mbx-2a20342e96294505a35eb5c8364eb67c"

Technically the message numbers can change from session to session, so if there are new messages coming in and messages being deleted you might need to try a few times, check the Date header or Received headers of the message you get to see if it matches. Normally in POP3 you would pull the list of messages and then retrieve the message in the same session (numbers only vary when you create a new session), but I don't think curl can work interactively like that (or at least, if it does, I haven't used it that way). Modern versions of Windows have curl built in, as well as nearly any Linux environment (including WSL).

You can use any POP3 client of your choice if you prefer, just be sure to leave messages on the server (CURL does this by default), and make sure to use encryption (STARTTLS or the dedicated TLS port are both acceptable).

MailStore Gateway's passwords are generated randomly and include punctuation, so it is easiest to paste it into curl each time, for example mine is "qn5x(/.B9M~PsZA92f]VYbIG`q{!1^[8" which would require an understanding of shell escape sequences to enter safely.

Finally, note that this assumes you have the gateway username and password. If not, you cannot proceed as all messages are stored at-rest using strong encryption, and the password is part of the decryption mechanism, do not try to reset the password as you will not get the message this way, and it will cause further issues.

Hopefully this helps, but let me know!
