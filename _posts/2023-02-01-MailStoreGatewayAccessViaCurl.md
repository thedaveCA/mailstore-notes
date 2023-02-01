---
title: Decrypt and access messages in the MailStore Gateway mailbox
categories: MailStoreGateway
tags: tips
published: true
---
MailStore Gateway has a POP3 server as part of the proxy functionality, but this also allows access to messages in the mailbox and therefore it is possible access messages directly using a tool like `curl` if you have a need to inspect of the messages in a decrypted state.

You'll obviously need the mailbox name and password.

In order to access the message, you first need to get the message number, then move on to retrieving the message.

Start with this command: 

    curl --ssl-reqd --insecure pop3://msgw.example.com/ -u "mbx-2a20342e96294505a35eb5c8364eb67c"

The response will look like this:

    1 91471

Now try doing a UIDL request as well: 

    $ curl --ssl-reqd --insecure --request UIDL pop3://msgw.example.com/ -u "mbx-2a20342e96294505a35eb5c8364eb67c"

The response will look like this:

    1 f558587b-b6d6-490d-b21e-eaf02172131a

In both cases above, there is a single message in the mailbox, the size is 91471 bytes and name is f558587b-b6d6-490d-b21e-eaf02172131a (technically this is the UIDL in the POP3 protocol, but MailStore Gateway generates UIDLs using file names).

Once you have the message number, you can download it by adding the message number to the URI:

    curl --ssl-reqd --insecure pop3://msgw.example.com/1 -u "mbx-2a20342e96294505a35eb5c8364eb67c"

Technically the message numbers can change from session to session, so if there are new messages coming in and/or messages being deleted you might need to try a few times, and you should verify using the Date header or Received headers of the message to make sure it matches.

Normally in POP3 you would pull the list of messages and then retrieve the message in the same session (numbers are consistent within a session but are allowed to change between sessions) but I don't think curl can work interactively like that (or at least, if it does, I haven't used it that way).

Modern versions of Windows have curl built in, as well as nearly any Linux environment (including WSL) so it is quick and easy to get going, and by default it leaves messages on the server whereas most other POP3 clients default to deleting messages after they're accessed.

MailStore Gateway's passwords are generated randomly and include punctuation, so it is easiest to paste it into curl each time, for example mine is "qn5x(/.B9M~PsZA92f]VYbIG`q{!1^[8" which would require an understanding of shell escape sequences to enter safely.

Hopefully this is useful to someone.
