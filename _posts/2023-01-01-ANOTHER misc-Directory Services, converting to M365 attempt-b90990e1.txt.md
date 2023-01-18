---
title: ANOTHER misc-Directory Services, converting to M365 attempt-b90990e1
categories: MailStoreServer MailStoreSPE
tags: M365
published: false
--- 
Happy to help! 

Could you first go to Administrative Tools --> Users --> Directory Services and check the Directory Services type that is in use, how you will proceed depends on the current selection.

# Microsoft 365 Basic, username format includes @domain, therefore usernames are not changed when you switch to Microsoft 365 Modern: 

If you are already set to Microsoft 365 Basic, and the username format includes the @domain, then you can follow this article to set up Microsoft 365 (both Directory Services, and then archiving): 
https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_-_Modern_Authentication
And this is all you need to do. 

# Any other Directory Services option

If you are using any other Directory Services option then it is possible that changing to Microsoft 365 Modern would cause users to be renamed as Directory Services with Microsoft 365 Modern requires that all users are named using the username@domain format. If your usernames would not change then just follow the article above. 

If changing this would cause users to be renamed then there are two ways to proceed: 

## Rename users, and switch to Microsoft 365 Modern Authentication completely: 

You could rename users and their archives to match the new username format, this is covered in this article: https://help.mailstore.com/en/server/Changing_Archiving_from_Microsoft_Exchange_Server_to_Microsoft_365

Although titled "Exchange Server to Microsoft 365" this article applies any time you are changing Directory Services in a way that causes usernames to change.

If you take this approach you are done here.

## Leave Directory Services as-is, users are not renamed: 

If you are using LDAP, Active Directory, Application Integration, or anything other than Microsoft 365 Basic, you can leave your Directory Services as-is. In this case you can follow our "Hybrid" option: https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_Hybrid "local Active Directory of your company" section but I'll describe the specific steps here: 

In MailStore Client go to Archive E-mail --> Servers --> Microsoft 365 --> Multiple Mailbox, click the [...] to access the credentials manager.

Refer to https://help.mailstore.com/en/server/Synchronizing_User_Accounts_with_Microsoft_365_-_Modern_Authentication

Perform 2.1 Registering of MailStore Server as App in Azure AD.

Perform 2.2 Creating Credentials in MailStore Server, but start at the "In the Credential Manager that appears, click on Create…" line as we are already in the credentials manager. 

Perform 2.3 Publishing Credentials in Azure AD.

Skip: 2.4 Configuring App Authentication in Azure AD
Skip: 2.5 Configuring the Redirect URI in MailStore Server

Perform step 2.6 Configuring API Permissions in Azure AD. 

Stop here, you now have the credentials and permissions registered, and your Directory Services has not changed. You are now ready to create a new Microsoft 365 Multiple Mailbox profile that replaces your current Exchange-type Multiple Mailbox profile, or any other profiles as needed. Journal profiles should not need any changes as journals always used an external mailbox anyway and can still authenticate. 

The full M365 article for reference: https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_-_Modern_Authentication


