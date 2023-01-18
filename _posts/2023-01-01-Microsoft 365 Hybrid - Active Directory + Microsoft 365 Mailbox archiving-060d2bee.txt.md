---
title: Microsoft 365 Hybrid - Active Directory + Microsoft 365 Mailbox archiving-060d2bee
categories: 
tags: M365
published: false
--- 
This article is intended to cover situations where you intend to leave Directory Services set to Active Directory, and archive mailboxes either from Microsoft 365, or a combination/hybrid of Microsoft 365, on-premises Exchange, or other platforms. 

To confirm your configuration matches, there are two things to check: 

MailStore Client > Administrative Tools > Users > Directory Services, is set to "Active Directory"
MailStore Client > Archive E-mail, you have one or more Exchange "Multiple Mailbox" profiles, but no "Journal" profiles.

There are places in our documentation where it discusses switching Directory Services to Microsoft 365 Modern Authentication. While it is possible to make this switch if you want, the process is more involved as it requires renaming users and their archives to match. If you just switched Directory Services to Microsoft 365 without making the other necessary changes the result would be that MailStore would re-archive entire copies of all mailboxes creating a whole bunch of duplicates. If users login to access MailStore (especially from outside of a VPN) it might make sense to use Microsoft 365's Modern Authentication so that users login to MailStore via their 365 login process, but please let me know before proceeding. Assuming that we are sticking with Directory Services, then proceed.

We do have the "Hybrid" article published now, it is available here: https://help.mailstore.com/en/server/Archiving_Emails_from_Microsoft_365_Hybrid and effectively are following the "App Registration & User Synchronization" section, but it is suited to new deployments more than existing installations. As you have an existing configuration, I'm going to provide the steps that apply specifically to your situation.

In our Hybrid article it says to refer to the "Synchronizing User Accounts with Microsoft 365" article to register the application, we will still use that article but complete the steps a bit differently.

Open https://help.mailstore.com/en/server/Synchronizing_User_Accounts_with_Microsoft_365_-_Modern_Authentication

Skip: 1 Prerequisites, Recommendations and Limitations
Skip: 2 Connecting MailStore Server and Microsoft 365

Perform this step: 2.1 Registering of MailStore Server as App in Azure AD

Perform this step: 2.2 Creating Credentials in MailStore Server, but with a slight modification.

In step 2.2 the article says to start at Administrative Tools > Users and Archives > Directory Services". Instead, go to Archive E-mail > E-mail Servers > Microsoft 365 -> Multiple Mailbox, and now beside the Credentials click the (...) button. This opens the credentials manager, but it avoids touching the Directory Services panel at all since we want to leave it set to Active Directory. In the article pick up at the "In the Credential Manager that appears, click on Create…" step.

Perform this step: 2.3 Publishing Credentials in Azure AD

Skip: 2.4 Configuring App Authentication in Azure AD

Skip: 2.5 Configuring the Redirect URI in MailStore Server

Perform this step: 2.6 Configuring API Permissions in Azure AD

Stop here. Skip steps 2.7, 2.8, and everything else beyond this point as you already have these configured for Active Directory.

Now you should be ready to set up archiving.

Return to MailStore Client and look at your existing Exchange profiles, for each one that connects to Microsoft 365 you'll need to create a new profile using the E-mail Servers --> Microsoft 365 profile to replace the existing Exchange profile. If you have any Exchange profiles that point to an on-premises Exchange (or any other profile types at all) leave them in place, you can mix and match profile types.

If you have just one Multiple Mailbox profile it is probably straightforward to set up the new one, but if you have more than one profile and/or want to verify all the settings match, you can open two copies of MailStore Client and run them side-by-side, allowing you to edit the properties of an existing Exchange profile while you create a new Microsoft 365 profile.

Whether you do it side-by-side or not, I would recommend first right clicking on an existing profile and setting it to Manual mode, then create the new Microsoft 365 profile to replace it. At the end of the profile creation process you can run the profile immediately to allow you to monitor the progress in the Progress View or you can go straight to scheduling it to run automatically in the background and check it later. If you open the Progress View, then as long as it gets to the point where the number of processed messages appears and is above 0 then you're authenticated successfully and the rest should work fine. You can either let it go and monitor the progress in the Progress View, or you can return to the main window of MailStore Client, right click the new Microsoft 365 profile and set it to Automatic mode. Switching to automatic mode will cancel the interactive profile execution and start the profile in the background immediately, and you'll be able to see the results in the Recent Results panel when the profile execution finishes.

If you have more than one profile to re-create you can work through the next profiles now, or you can leave some using Exchange mode while others work in Microsoft 365 mode (at least until December, when Microsoft disables basic authentication).

Like I said earlier, hopefully all of this makes sense. I'm writing up these steps based on our documentation updates rather than using the older internal article, so if anything isn't clear please let me know.