---
title: 2023-00-00-MailStoreGatewayRedundancy
categories: MailStoreGateway
tags: tips
published: false
---

MailStore Gateway was not designed with this in mind, but it would be possible with some understanding of what is happening. First consider if it is really needed, remember that journal messages being delivered to the gateway are regular emails and therefore have normal retry mechanisms on the part of the sender, so brief outages to install updates are not normally a problem as the messages will simply be re-sent.

The supported option and our recommendation is to have a regular backup of the gateway's configuration so that you can recover/restore if a longer outage occurs.

However, you can have the backup already ready to go, and once you understand the concepts the steps are the same to actually archive from both gateways at the same time, giving a high-availability concept. Note that I am assuming you only use the gateway to receive journal/multidrop messages, this does not apply and does not work the same for POP3 proxy mode.

We will call them msgw1.example.com and msgw2.example.com, each with their own public IP and DNS A-record.
1) Install MailStore Gateway on msgw1.
2) Configure the certificate (self-signed is fine) to the name msgw1.example.com.
3) Configure using the domain name msgw.example.com (no number).
4) Create a mailbox, it will be in the format mbx-#@msgw.example.com.
5) Backup the configuration files as described at https://help.mailstore.com/en/gateway/Backup_and_Restore
6) Install MailStore Gateway on msgw2.
7) Configure the certificate (self-signed is fine) to the name msgw2.example.com.
8) Restore the configuration files created in step #5.

You will now have two Gateway servers that can receive mail to the same mailbox name and use the same credentials and other details.

In MailStore Server, create two identical profiles, one pointing to msgw1.example.com and the other pointing to msgw2.example.com.

Finally, create a pair of MX records for msgw.example.com that point to msgw1.example.com and msgw2.example.com

These could look like this:

msgw.example.com IN MX 0 msgw1.example.com.
msgw.example.com IN MX 0 msgw2.example.com.

You can adjust the priorities if needed, for example, if msgw2.example.com were installed at a remote location it might make sense to use priority 1 for the local msgw1, and priority 2 for the remote msgw2 so that journal messages tend to be delivered locally first.

When you set up journal rules, point to mbx-#@msgw.example.com (again, without a number), so that the sending server can deliver to either place.

However, note that MailStore Gateway was not specifically designed with this in mind, and as a result care must be taken. You must only make configuration changes on one gateway and then copy the configuration file to the other (remember the gateway was designed to be backed up, and later restored to a new system, so we need to follow the same process). For example, you cannot create a new mailbox on each because the mailbox names and passwords are generated randomly and would not match, so instead you must make changes on msgw1, stop the service, copy the configuration files to msgw2 where you stop the service, restore the configuration file, and start the services again. Be sure to only copy the configuration files and not the mailboxes themselves (the gateway will create mailbox directories automatically when needed).

Additionally, MailStore Gateway's web interface will stop you from doing harmful things, for example, you cannot delete a mailbox without appropriate warnings about disabling it and deleting the messages, whereas copying the configuration file would have no such warning, so you would need to be sure that there are no messages in the mailbox.

Similarly, be aware that MailStore Gateway stores all user messages encrypted, with the encryption key using the mailbox password, so if you ever reset a mailbox's password you could lose access to encrypted messages on the other server. Here are two examples:
1) To change the password of a mailbox on gateway 1, you need the mailbox to be empty, switch it to suspended status, then you can reset the password and re-enable the mailbox.
2) Copy the configuration file from msgw1 to msgw2.
You will now find that any messages in msgw2's mailbox cannot be decrypted and are effectively lost.

1) Reset the password of a mailbox on msgw2.
2) Copy the configuration from msgw1 to msgw2.
Again, you will find that any messages in msgw2's mailbox cannot be decrypted, and are effectively lost.

Because of these types of risks Gateway is not designed to be used in this fashion, and I would recommend having a backup available rather than running fully redundant, but fully redundant is entirely possible if care is taken. Finally, because there is no high availability in the formal design, future updates may introduce other complexities in this setup that would make this more difficult to maintain.
