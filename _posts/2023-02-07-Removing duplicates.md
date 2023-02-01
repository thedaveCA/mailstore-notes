---
title: Removing duplicates
categories: MailStoreServer MailStoreSPE MailStoreHome
tags: tricks
published: true
---

## Introduction

MailStore does not have any formal deduplication feature.

While archiving MailStore checks each message in the source mailbox to see if it is in the archive in the correct location, skipping messages already in the archive, so in normal operation you should not see duplicated messages.

However, if a user or a mailbox is renamed, you might end up with two different sets of folders for the same user, and although you can merge these together, if the two folders contain the same messages you'll end up with duplicates.

Because MailStore's archiving process skips messages already in the archive we can export, delete and re-archive the messages, skipping the duplicated messages in most cases.

You must first finish merging and organizing messages in MailStore before proceeding.

## Account

You can perform these tasks as the *admin*, but you need to unblock access to the archive under *Administrative Tools* -> *Compliance* -> *Compliance General*.

Alternatively an individual user can perform most of these steps. The user account must have *Archive E-mail*, *Export E-mail*, *Delete* permissions on their account and also *Full Access* to their archive. The admin will still need to be involved with certain steps, so it is best to perform the following steps as an administrator.

Login to MailStore using whatever account you like, all of the steps will be performed in *MailStore Client* using the same account other than any *Administrative Tools*  steps must be performed by an admin.

## Select the messages

This step is optional, but in some cases you'll be able to narrow down the range of messages using the search filter. If this is not possible, you can perform the following steps on individual folders, entire user archives, or across the entire MailStore archive as you prefer.

Start by finding a few examples of duplicate messages, they should already be in the same folder and will have the same *Date*, but they may be archived on different dates, if so the goal is to determine the date that the duplication occurred. You can select a wider date range if you like.

1. Go to *Search E-mail*
2. Click the *New Query* button.
3. Optional: Click the Folder *[...]* button and select a starting point. You can leave this blank to work across the entire archive.
4. Set the *Date* field to find messages older than the date the duplication occurred.
5. Set the *Archived Date* field to find messages *not older than* than the date the duplication occurred.
6. Click the *Create Search Folder*, save the search.

You can review the search if you want, hopefully it will contain one instance of each duplicated message but it may contain both copies of the duplicated messages and/or it may contain messages that are not duplicated. This is fine. The goal is to make sure that at least one instance of every duplicated message is found.

## Stop MailStore Archive E-mail profiles from running

It is highly recommend to stop all archiving tasks for the next steps. This can be done in more than one way:

* Launch the *Configure the MailStore Server Service* tool.
* Stop the service.
* Start in *Safe Mode*.

This will stop all background tasks, and only allow *admin* users to login

-OR-

* Go to the *Archive E-mail* panel
* Select *Show Profiles of All Users* at the bottom.
* Select each of the profiles that have a spinning circle, right click, select *Manual*.

Whatever step you take, be sure to keep track of what you changed so you can revert the change later.

## Export the messages

1. Go to *Export E-mail*
2. Create a new *E-mail Files* export, *Directory (File System)*, type *EML files*
3. Set the *Scope* to the messages to be deduplicated, this can be the saved search folder created in the previous step or any other folder you like. Subfolders are included.
4. Set the *Target Folder* to a local directory that has enough space. I'll use `C:\EML`. The directory will be created as needed.
5. Enable both *Retain folder structure* and *Update existing export*.
6. Complete the profile and *Run*.

A note about the folder you select:

While most operations in MailStore Server use folders relative to the server, in this case we're using a folder relative to the client. So for example, if MailStore Client is installed on your personal workstation and you export to `C:\EML` the files will be written to your workstation instead of the server.

It is possible to use a mapped network drive, UNC path, or external drive, but I would recommend finding a machine with sufficient local internal storage instead as this process is dependent on your disk performance.

## Delete the messages

Once the export finishes, return to *MailStore Client* and delete the messages.

### If you exported the entire MailStore archive

1. Go to *Administrative Tools* -> *Storage* -> *Storage Locations*
2. Right click on each Storage Location and *Detach*
3. Create a new Storage Location. MailStore's default name is in the format *YYYY-MM*, I would recommend staying with this format.
4. Set it to *Archive Here*.

### If you used a saved search folder

1. Navigate to the saved search.
2. Select the top-most message (single click).
3. Scroll to the bottom, *Shift-Click* the bottom-most message to highlight the range.
4. Right click on any selected message and select *Delete*.

### If you exported any other folder

1. Right click on the folder.
2. Select *Delete*.

## Re-archive any missing messages

Now we'll re-archive the EML files that we exported.

1. Go to *Archive E-mail*.
2. Select *E-mail Files*.
3. Select *EML and MSG files*.
4. Select type *MailStore Export*.
5. Set the folder (`C:\EML` in my case).
6. Leave other options at their defaults (*Include Subfolders*, *Read MailStore Headers* enabled, *Verify Signature* disabled).
7. Click *Next >*
8. Leave all *Advanced Settings* at their defaults.
9. Click *Next >*
10. Under *Target Archive* select the *admin* user, or your own user. This archive is not used, but the field must be set.
11. Complete the profile and *Run*.

This will re-archive all of the exported messages, skipping messages already in the archive. If you were able to use a *Search E-mail* folder to select just a subset of messages then most messages will be skipped but there may be a few messages that were in the selected date ranges that did not get duplicated and we want to make sure we get these messages re-archived.

It is possible that you won't have any messages get archived here at all.

When the profile finishes click the *Details* link, all messages should either be archived, or skipped because they were already in the archive.

## Cleanup

### Re-enable archiving

You can now return MailStore to normal operation by undoing whatever steps you took in the *Stop MailStore Archive E-mail profiles from running* step.

### Free up disk space

Depending on how you deleted the messages, you might be able to get some disk space back.

#### Deleted all Storage Locations

If you deleted all of your *Storage Locations*, you can now delete the files associated with these old Storage Locations. Be sure to not delete the new Storage Location.

If you use MailStore's internal backup feature go to the backup directory and delete all of the *Filegroup###* directories as MailStore's backup will not do this automatically. The next time MailStore's backup runs it will copy all files that are not in the backup directory.

#### Deleted messages or folders

If you deleted messages or folders (but not all Storage Locations) then you might consider running a Compact operation on your Storage Location(s).

You won't get a lot of space back as much of the content would have been handled by the single-instance-storage system within the Storage Location but there will be some space recovered.
