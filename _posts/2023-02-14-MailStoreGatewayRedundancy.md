---
title: Load-balance MailStore Gateway
categories: MailStoreGateway
tags: tips
published: true
---
Have you ever wondered if you can run MailStore Gateway in a load-balanced or high-availability configuration?

MailStore Gateway was *not* designed with this in mind, but that doesn't mean it can't be done. Is this really needed though? In most situations, probably not. Keep in mind that journal messages are just e-mails, and e-mail uses SMTP which includes retry mechanisms. Brief outages will not cause you problems (but screwing up the gateway configuration will!)

However, there are some obvious advantages to having two Gateway servers, a big one being that they could live in totally different hosting facilities which is great for redundancy. A MailStore Service Provider Edition operator might need the redundancy. Nonetheless, *supported* official recommendation is to have a regular backup of the gateway's configuration so that you can recover/restore if a longer outage occurs.

---

We'll assume we have an existing MailStore Gateway at the domain `msgw.example.com`, and we're bringing up a new server called `msgw1.example.com` and then a second `msgw2.example.com`, this pair eventually replacing the original gateway completely.

Currently you should have a DNS *A* record for *msgw.example.com* which points to the IP of the single server, leave that in place for the moment.

1) Install MailStore Gateway on *msgw1.example.com*.
2) [Backup the configuration](https://help.mailstore.com/en/gateway/Backup_and_Restore) on the existing server, and restore it to *msgw1.example.com*.
3) Create a certificate (self-signed is fine, signed is better) named *msgw1.example.com*.
4) Create a public facing A-record for *msgw1.example.com* pointing to the appropriate IP.
5) In MailStore Server, create a new Gateway profile to archive from the new server, identical to your current one except the hostname is *msgw1.example.com*.
6) Create a MX record for *msgw.example.com* that points to *msgw1.example.com* (and if you have an existing MX record for *msgw1.example.com*, remove it).

Over the next few minutes incoming mail addressed to `@msgw.example.com` will start to be delivered to the new *msgw1.example.com* server instead, although you'll see some messages being delivered to the original *msgw.example.com* server (potentially for several hours).

The key here is that we're now using MX records (which point to an A-record) rather than the typical gateway configuration which just uses an A-record.

Now do it again, for *msgw2.example.com*, adding a second MX record for *msgw.example.com* pointing to *msgw2.example.com* and leaving the original *msgw1.example.com* in place.

Your MX records will look something like this:

    msgw.example.com IN MX 0 msgw1.example.com.
    msgw.example.com IN MX 0 msgw2.example.com.

You can use the same priority (0) for both to have inbound mail balanced between the two, or differing priorities (e.g. 0 and 10) to have mail primarily delivered to the lower-numbered record, with the second being used as a fallback.

To be clear, MailStore Server will need two journal profiles, one pulling from each Gateway.

You might be wondering why we bothered with the `msgw1.example.com` rather than just using the current one? No technical reason, but rather I explained it this way to show the concept: You're really just creating a backup, and using MX records to deliver to both.

Could you just clone the servers, call them both *msgw.example.com*, and use a pair of A-records to distribute mail? Technically yes, but e-mail sender failover is less well defined in this situation. Additionally, by using unique hostnames with matching certificates you can avoid certificate errors in on the MailStore Server side.

On the topic of certificates, the certificates should match the actual hostname of each server (*msgw1.example.com*) even though messages are addressed to *@msgw.example.com*.

If you need to make any configuration changes in the future, for example adding another mailbox, create the mailbox on one gateway server and then copy the configuration file to the other.

If you ever need to change a mailbox password, the process is a lot more complicated due to the fact that MailStore Gateway stores messages encrypted at rest, and the password is required to decrypt. For this reason I would strongly advise that you create a new mailbox, set up new archiving profiles and switch the journal rules rather than changing passwords. A password rotation could be accomplished, but it is a lot simpler to use a new mailbox.
