---
title: Using Active Directory with Microsoft 365 mailboxes (Modern Authentication)-916862f7
categories: MailStoreServer MailStoreSPE
tags: M365
published: true
--- 
# MailStore's article about this
https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_Hybrid

---
# My thoughts / Previous article

It is possible to switch to Microsoft 365's Modern Authentication for the purposes of archiving while still using Active Directory as a user synchronization source, and in fact this is easier as it avoids needing to rename the archive folders in your existing archive to match. We will borrow some of the steps from our published documentation, but there are others that we can skip.

As long as your Microsoft 365 environment is synchronized with your local Active Directory, MailStore can use either option as a source for user information and can archive from both Microsoft 365 mailboxes and your on-premises Exchange as well if you happen to have a hybrid environment.

To set things up, login to MailStore Client with an *admin* account, go to *Archive E-mail*, under *Servers* click *Microsoft 365*. Select *Multiple Mailboxes*. Now click the `...` button, which will open the *credentials manager*.

Now we will use the [Synchronizing User Accounts with Microsoft 365 (Modern Authentication)](https://help.mailstore.com/en/server/Synchronizing_User_Accounts_with_Microsoft_365_(Modern_Authentication)) help page article, but start at the step *In the Credential Manager that appears, click on Create…*

Start at *step 2.1*, register the app, create credentials and then publish the credentials.
1. Complete *step 2.1 Registering of MailStore Server as App in Azure AD*.
1. Complete *step 2.2 Creating Credentials in MailStore Server*.
1. Complete *step 2.3 Publishing Credentials in Azure AD*.

Stop at and skip *step 2.4 Configuring App Authentication in Azure AD*.
Skip *step 2.5 Configuring the Redirect URI in MailStore Server*.

We skip these two as they only apply to synchronizing users with Microsoft 365, but we are intending to stay with Active Directory

Next we need to grant API permissions, I would recommend adding all permissions here even though we are not actually synchronizing the directory.

1. Complete *2.6 Configuring API Permissions in Azure AD*.

Stop at *Step 2.7 User Database Synchronization* and skip the remainder of the article.

Now that the credentials have been created you can set up Microsoft 365 archiving profiles. For information refer to the [Archiving Emails from Microsoft 365 (Modern Authentication)](https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_(Modern_Authentication)) article. The principles are the same as your existing "Exchange" profiles, so you can probably skip directly to the section that covers [Archiving Multiple Microsoft 365 Mailboxes Centrally](https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_(Modern_Authentication)#Archiving_Multiple_Microsoft_365_Mailboxes_Centrally).


