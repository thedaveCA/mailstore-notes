---
title: Migrating a "live" MailStore Server using robocopy
categories: HelperArticles
tags: importing tips
published: true
permalink: mailstoreserver/livemigration/robocopy/
---

Be sure to first read the [Migrating a "live" MailStore Server](/mailstoreserver/livemigration/) article first. Also available is [rclone instructions](/mailstoreserver/livemigration/rclone/).

### Pre-staging the data

You cannot copy all of MailStore's databases while the server is running, but if you're comfortable with the command line, we can pre-stage the bulk of the database so that the required downtime is minimal.

If you have any questions or have not used robocopy before, take great care. In particular, understand that some commands (`/purge` and `/mir`) not only copy but also delete files in the target. If you were to type `D:\ MailArchive` instead of `D:\MailArchive` robocopy would happily delete most of your files on D:\ for you.

Let's assume you're running the commands from the new server, and putting the database in `D:\MailArchive`, while the old database is at `\\oldserver\c$\MailArchive`.

You can add `/mt` to the end of any of these commands to make them run multi-threaded, increasing the disk I/O and giving you delayed output.

We'll start off by copying the content *.DAT* files, this will be a substantial portion of the database and most of these are not being modified (the most recent handful may be modified, and new ones are created, but that's ok).

    robocopy \\oldserver\c$\MailArchive D:\MailArchive *.dat /xf index* /s /r:2 /w:2 /minage:1

You'll possibly have a few errors, that's fine and they can be ignored at this stage. Run it again if you want it to get caught up on any remaining files, but don't worry about getting every last file.

Now we'll run it again copying even more files, excluding the `.fdb` files as these will be modified. Additionally we'll skip anything modified in the last day as these are likely to be modified again.

    robocopy \\oldserver\c$\MailArchive D:\MailArchive /xf *.fdb /s /r:2 /w:2 /minage:1

Now we're ready to stop archiving, so login to the existing server with MailStore Client, go to the *Storage Locations* panel, find the Storage Location marked as *Archive Here* and switch it to *Normal*, and copy everything except the `.fdb` files:

    robocopy \\oldserver\c$\MailArchive D:\MailArchive /xf *.fdb /s /r:2 /w:2

This will copy the remaining index files and recovery records even if they've been modified recently, but still skipping the .fdb files as they will be modified by MailStore again. You can run it again to retry any errors, but it isn't critical.

### Complete the copy

Finally, stop the service on the old server (and if you already installed the service on the new machine, make sure it is stopped there too) and complete the copy with one final robocopy pass:

    robocopy \\oldserver\c$\MailArchive D:\MailArchive /e /purge /r:2 /w:2

In this case there should be no errors, if you see any errors at all then make sure the service is stopped (on both sides) and run it again as needed until successful.

Note that the `/purge` command instructs robocopy to copy, update, change and delete whatever files are necessary so that the target completely matches the source, meaning that it will delete files in the destination.

### Leave the old server in read-only mode

At this point you can bring up MailStore on the existing server again and leave it serving users (but not archiving) by leaving the Storage Location in *normal* status. All archiving will remain paused.

### Start up the new server

If you haven't already, install MailStore Server on the new server, launch the *Configure the MailStore Server Service* tool on the new server, go to the security tab and initialize encryption, you'll be prompted for the old encryption recovery key (by default, the product key although you may have a custom one configured). This does not transfer the license.

You can now start the service on the new server, run any pending database upgrades, compact, perform Storage Location consolidations, re-indexing, or whatever else is needed.

### Complete the process

Once you're ready for the new server to start archiving, just switch the Storage Location that was formally set to *Archive Here* back to that status.

You're now ready to uninstall the old MailStore Server installation, transfer the license and switch users over.

## Licensing

From a licensing standpoint, only a single server can use the license at once, but you could acquire another license, or use a 30-day trial license on the new machine.

 MailStore Server's 30-day trials have one limitation that you won't encounter when doing a normal 30-day trial: You cannot view messages that have been in the archive more than 30 days ago. You can still see the messages in the list, search, and access all administrative functions but the message bodies themselves have a trial overlay blocking access to the message body, which is fine for our purposes.

Hopefully everything here is clear, but if not, please don't start the process until you really understand what it is going to do.
