---
title: Extracting unknown e-mail addresses from journal-type profile's debug log
categories: MailStoreServer MailStoreSPE
tags: ServerUnmappableException importing
published: true
permalink: MailStoreServer/ServerUnmappableException
--- 

## Bulk import of messages without a list of all known e-mail addresses

### Preface

This article describes how to perform a one-time archive or migration of messages into MailStore where the messages are available in EML files, PST files, an Exchange journal mailbox or a Multidrop mailbox and there is no definitive list of users / e-mail addresses available.

All steps are to be performed in MailStore Client, logged in as an admin, unless otherwise described.

I will be using `example.com` as the domain for my company in this article.

### Licensing

You will need a user license for each user for the archiving process. MailStore's 30-day trial has a 500-user limit and can be used for the initial archiving, or you could import users in batches instead.

### Creating the initial users (optional)

To start off with, if you will eventually be using Directory Services to synchronize users then you can set it up first. This step is optional, and Directory Services is not actually needed at all, but by first synchronizing users it will reduce the number of users that need to be manually created.

I'll be using the full e-mail address in this article but if your Directory Services synchronizes with Active Directory then it may use only the local part. You can modify the "CreateUser" API call slightly to accommodate. While it is possible to rename users/archives after the fact it will save some time to use the correct configuration from the server.

If you aren't using Directory Services or simply are not ready to synchronize users, you just need at least one user with an e-mail address attached to their account. You could edit the admin account and set `admin@example.com` for the address.

### Archiving Profile

You can archive from EML files, PST files of type *Multiple Users* or *Exchange Journal*, or *Multidrop* accounts, the process is similar for all message sources.

#### EML files

- Go to *Archive E-mail*.
- Create a new profile --> *E-mail Files* --> *Multiple Users*.
- Set the *Directory* to a directory that contains the EML files to be archived.
- Set "Messages with unknown e-mail addresses" to "Don't archive".
- Leave "Delete them in origin mailbox" unchecked.
- Run the archiving profile.

#### Running the archiving profile for the first time

You can start with a subdirectory that contains a few messages to understand the process, and later run the profile again against the same messages without duplicating any messages in the archive. Depending on the amount of mail you have to import, it may take several hours to perform the initial archiving run which generates the list we will use going forward.

Any user that already exists in MailStore at this point will have their messages archived, while messages that do not belong to any known user will have a debug log entry created, providing us a list of needed users.

### Get the debug log

- Click *Details*.
- You should see a number of messages that are skipped with the message `because the target user archive could not be determined based on the e-mail addresses`.
- Click on *Debug Log* and *Select in Explorer*.
- Copy the log file to another directory as MailStore will remove the file when you close the dialog.
- Return to the details dialog and close it (this dialog blocks further access to MailStore Client).

You may want to open the log to take a look, in which case look for the lines that look like this:

`MailStore.Common.Interfaces.ServerUnmappableException: MailStore is unable to determine where to store this email. Please ensure that e-mail addresses are specified in the users' settings. Senders and recipients: noreply@mailstore.com, sherry.hall@example.com, frank.clark@example.com`

`noreply@mailstore.com` is an example of an external address, while the`@example.com` addresses belong to our example company in this documentation. Note that there may be any number of addresses, but most messages will just have two.

### Get the e-mail addresses out of the debug log

We need to get the e-mail addresses from the debug log lines above into a list, one e-mail address per line, with all other punctuation and spaces removed. Duplicates will not cause errors, but will take time to process, so it is ideal to remove them from the list but it is not required.

There are a lot of ways you can do this, including doing it entirely by hand for a small number of users, or you could use any regex capable editor or other tools. If you are doing it manually and miss a user, just create the user and run the archiving process again, MailStore will skip the messages already in the archive.

Aside from preparing this list manually, I will describe three ways to extract the data from the debug log.

The goal is to change this:

```log-entry
MailStore.Common.Interfaces.ServerUnmappableException: MailStore is unable to determine where to store this email. Please ensure that e-mail addresses are specified in the users' settings. Senders and recipients: noreply@mailstore.com, sherry.hall@example.com, frank.clark@example.com
MailStore.Common.Interfaces.ServerUnmappableException: MailStore is unable to determine where to store this email. Please ensure that e-mail addresses are specified in the users' settings. Senders and recipients: joe.smith@example.com, frank.clark@example.com
```

To a test file called `userlist.txt` that looks like this:

```log-entry
sherry.hall@example.com
frank.clark@example.com
joe.smith@example.com
```

Note that the original list had external addresses like `noreply@mailstore.com` that were removed, and also `frank.clark@example.com` was listed twice but is now only listed once.

If you built the *userlist.txt* file manually, move ahead to **Create the users**, otherwise read on for automated ways of creating the list.

#### Linux / bash command line

The Linux/WSL steps are [located in a separate article](/MailStoreServer/ServerUnmappableException/linux_wsl/) and will only take a couple of minutes to complete.

#### Manually (via Excel)

The Excel steps are [located in a separate article](/MailStoreServer/ServerUnmappableException/excel/) and only needed if you do not have access to a Linux console for a few minutes.

### Create the users

- Return to *MailStore Client*.
- Right click on the profile created earlier and select *Create Scheduled Task*.
- Click *Copy CMD Line*, then cancel the scheduled task dialog.
- Paste the line into your favourite text editor.

The details of the line will vary, mine looks like this:

`"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --cred="admin@127.0.0.1" -c import-execute --id=3 --user="admin" --verbose`

We need the part up to and including `-c`, so like this:

`"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --cred="admin@127.0.0.1" -c`

First we need to create each user, which we can do using a `for` loop through the *userlist.txt* file created above.

```cmd.exe
for /F %x in (userlist.txt) do "C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --cred="admin@127.0.0.1" -c CreateUser --userName %x --privileges "none"
```

Then set the e-mail addresses field:

```cmd.exe
for /F %x in (userlist.txt) do "C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --cred="admin@127.0.0.1" -c SetUserEmailAddresses --userName %x --emailAddresses %x
```

A note about using bare usernames (without the `@example.com` domain portion): You could remove the domain from the lines in *userlist.txt* and then when setting e-mail addresses replace the `--emailAddresses %x` part with `--emailAddresses %x@example.com` instead.

Creating totally different usernames and e-mail addresses (e.g. `fclark` and `frank.clark@example.com`) or listing multiple e-mail addresses is out of scope for this article, but you could modify the command lines above to match your environment.

### Running the archive profile

Once your users are created, return to the *Archive E-mail* panel and run your `Multidrop Mailbox (File System)` profile again, this time it should process all messages.

Click the *Details* link again to review the results. If there are any messages that still don't have a user associated with them, create the missing users and repeat the archive.

It is likely that you will have *new messages* archived and some *messages already existed in the archive*, but you should not have any further *messages have been skipped*.

### Cleanup unneeded users

At this point all of your source message files have been archived, and these files are no longer needed by MailStore.

It is likely you'll want to delete the users created, you can do this using this command:

```cmd.exe
for /F %x in (userlist.txt) do "C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --cred="admin@127.0.0.1" -c DeleteUser --userName %x
```

Note that this will remove all users listed, including those that were previously created by Directory Services.

Instead you could also use MailStore Client's *Users* list. In this case, select all users, hold control and unselect the current admin user, then delete all users.

If any users were created by Directory Services and deleted above they will be recreated by Directory Services again, with their default set of permissions.

### Final notes

A few more bits of information about the process that did not fit neatly above.

### Creating a user that has permissions to access the entire archive

You will likely now need to create one or more users that have access to the entire archive. From the users editor you can give a user the ability to read a specific archive, but this would take a lot of clicking to give a single user access to many archives.

Instead you can create an *Auditor* user that has read access to all archives without admin permissions. Go to *Compliance* -> *Compliance General* and create an auditor user.

You can create multiple auditor users if desired and once they're created you can rename them to the user's normal account name. If the target user already exists from Directory Services, delete their old account and rename the auditor user, then change their *Authentication Type* to `Directory Services`. Directory Services will update the full name and e-mail address the next time it synchronizes.

#### User Interface

In the *Progress View* dialog when you click the *Details* link, the dialog blocks you from accessing MailStore Client's interface until it is closed. I would therefore commend opening the debug log via Windows Explorer, copy the file, and return to MailStore Client to close this dialog otherwise it appears that MailStore Client is hung if you try to access other dialogs.

The debug log is only preserved while you leave *Progress View* open, if the *Debug Log* button is missing you are probably looking at Recent Results which does not contain the needed information.

#### Archiving

MailStore's archiving profiles all skip messages already in the target archive/folder, therefore there is no need to remove messages in the archive if you repeat the process after creating new users or adding more EML files.

If you change the folder names in the archiving profiles, this *will* cause duplicates to be created. I would recommend using the defaults, or at least, be sure to get it right.

#### Do not delete messages from the source until you're done

While it might seem like you could save some time by having MailStore delete the source messages during each archiving profile execution so that you do not need to re-scan all messages that have already been archived, this is not recommended as it has an unexpected consequence.

The important thing to understand is that MailStore does not have any concept of your domain or any way to determine what is a local user or non-local user. MailStore just has the list of currently-licensed users and their e-mail addresses. Imagine we have `frank@example.com` created, but `bob@example.com` has not been created yet and then archive with the option to delete messages enabled, here is what will happen:

- The first message is from `noreply@mailstore.com` and to `frank@example.com`, so it gets archived, and deleted. Great, this is what we want.
- The second message is from `noreply@mailstore.com` and to `bob@example.com`, so it gets skipped and logged, but not deleted. Great, this is what we want.
- The third message is from `frank@example.com` and to `bob@example.com`, so it gets archived to `frank@example.com` only -- This message is successfully archived, therefore if the delete option is enabled the message is deleted. When you later create `bob@example.com` the message is already gone from the source and therefore is never archived into into `bob@example.com` at all.

You will likely not even notice that `bob@example.com` is missing the messages, but even if noticed there is no way to find and fix this later. The message is not lost, it is in `frank`'s archive, but this can cause problems when reviewing just `bob`'s archive later.
