---
title: Securing your MailStore Server's public interface with a trusted certificate
categories: MailStoreServer
tags: 
published: false
--- 
1. MailStore can generate a self-signed certificate, this is the quickest and easiest to get up and running, but of course results in certificate errors.

2. You can deploy the certificate itself to client machines so that clients can connections to MailStore Server. There is no root certificate used, the certificate is entirely self-signed.

3. MailStore can use any certificate already installed on the machine.
    1. If you have your own certificate authority internally you can generate a certificate and install it on the MailStore Server's machine, and set MailStore to use it.
    2. You can acquire any trusted certificate (free or paid) online, install the certificate on the MailStore Server machine, and set MailStore to use it. Purchasing a single company-wide wildcard (*.example.com) is one option although this isn't the best solution for all environments.

4. MailStore has internal Let's Encrypt support, allowing you MailStore to generate, sign, and renew a certificate automatically. In this case MailStore must have a host name that is a FQDN (fully qualified domain name), have internet facing DNS records, and be reachable on port 80. MailStore only uses port 80 for the few moments while the /.well-known/acme-challenge/ request is being processed, but renewals will happen automatically in the background every 60-90 days.
