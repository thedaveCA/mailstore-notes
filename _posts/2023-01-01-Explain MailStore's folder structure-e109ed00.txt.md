---
title: Explain MailStore's folder structure-e109ed00
categories: information
tags: 
published: true
--- 
All messages in MailStore are within an individual user's archive, each user has a separate archive, so for example my incoming messages could end up in any/all of these depending on where the messages come from: 

`Archive of dwarren\Exchange dwarren\Inbox
`Archive of dwarren\Journal Incoming`
`Archive of dwarren\dwarren@example.com\Inbox`

I will skip typing "Archive of dwarren" going forward as it applies identically in all cases below. 

In this context, MailStore's archiving profiles can be broken down into two types that I'll discuss individually, "Individual User" and "Multiple User".

"Individual User" profiles are where there is a 1:1 relationship between the source mailbox and the owner of the messages in MailStore does not parse the headers to determine the owner. These start by knowing the target archive (user), then connect to a mailbox to find messages.  This includes Multiple Mailbox profiles such as Exchange Multiple Mailbox, as this type of profile is really just a series of Single Mailbox profiles, with a 1:1 relationship between each source mailbox and target archive. 

For Individual User profiles, each message is archived into only a single user (if you send a message, a separate copy will be retrieved from your Sent folder, but a copy is not placed in the recipient's archive, instead a copy must be found in their mailbox for it to appear in their archive in MailStore For these profiles the folder structure is preserved so you'll get folder structures that look something like this: 

Exchange mailboxes (Single and Multiple mailbox, but not Gateway or Journal):

Exchange $MAILBOXNAME$\Inbox
Exchange $MAILBOXNAME$\Sent Items
Exchange $MAILBOXNAME$\And more! 

IMAP mailboxes: 

$EMAILADDRESS$\INBOX
$EMAILADDRESS$\Sent
$EMAILADDRESS$\And more!

Local files and mail prepend the source (Outlook is both Outlook itself and PST files) and then mirror the folder structure.

Outlook $PSTTITLE\Inbox
Outlook $PSTTITLE\Sent Items
Outlook $PSTTITLE\And more! 

By "And More!" I mean all folders the user has created or otherwise exist in the mailbox. 

One quirk, Google doesn't have folders in the classic sense, and their Labels implementation is not compatible with the way MailStore organizes and deduplicates messages, so instead messages are sorted into only the Inbox and Send folder: 
$EMAILADDRESS$\Inbox
$EMAILADDRESS$\Sent


"Multiple User" type profiles have a "1:many" relationship, MailStore parses the headers of each message to determine the sender and recipients. These are Gateway/Journal/Multi-drop (mail belonging to multiple individuals is located in a single mailbox and MailStore must therefore parse the headers to determine the owner). MailStore starts with a message, then determines the target archive by parsing the sender and recipient(s), looking for matching e-mail addresses in MailStore's user list and placing a copy in each. Messages can have 0 or more target archives (for example, if you send a message to two co-workers, the single message can be archived into all three archives from one instance). 

For Gateway/Journal/Multi-drop profiles the folder structure is simpler: 

Exchange mailboxes target the "Journal" folders: 
Journal Incoming
Journal Outgoing

IMAP and local files use the e-mail address plus a \ as the root.
$EMAILADDRESS$\INBOX
$EMAILADDRESS$\Sent Items

In these cases there is no further folder structure possible, MailStore is sorting messages internally (in most cases all the messages came from the source's inbox folder).

The one quirk here, you can have messages in the source that have no matching user in MailStore, in this case the message can either be targeted to the "@catchall\Unknown E-mail Addresses" or skipped and left in the source mailbox. 



A couple other things to be aware of, within a target scope (The "Archive of" plus one more layer, so "Archive of dwarren\Exchange" and everything below, only one instance of a single message is allowed and subsequent copies will be skipped -- So if you copy a message from your Inbox to your "Important Stuff" folder on the server, in MailStore it is just in Inbox. When you delete it from your mailboxes' Inbox MailStore will now find the copy in your mailbox's "Important Stuff" folder and move the message in MailStore to match. 

Lastly, this all applies to how MailStore presents message in the interface. There is a single-instance-storage system that deduplicates on disk for storage savings as well. The single instance storage system is totally disconnected from where/how messages are stored in the interface, MailStore splits messages at the MIME part level and stores each MIME block once.
