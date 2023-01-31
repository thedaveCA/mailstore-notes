---
title: Migrating a "live" MailStore Server using rclone
categories: MailStoreServer
tags: importing tips
published: true
permalink: livemigration-rclone
---

Be sure to first read the [Migrating a "live" MailStore Server](livemigration) article first. Also available is [rclone instructions](livemigration-rclone).

### Pre-staging the data

You cannot copy all of MailStore's databases while the server is running, but if you're comfortable with the command line, we can pre-stage the bulk of the database so that the required downtime is minimal.

If you have any questions or have not used rclone before, take great care. In particular, understand that some commands (`sync`) not only copy but also delete files in the target. 

First use `rclone config` to create a remote called `source` and `destination`, you can then perform the tasks from either machine, or a third machine entirely if desired.

One of the perks of rclone is that you can use it to copy and synchronize files across a variety of different protocols, the configuration and details are out of scope for this article.

You can use `--transfers` to the end of any of these commands to make them run multi-threaded, increasing the disk I/O and giving you delayed output.

I would also recommend `--progress` to monitor the progress in real time, and `-v` (verbose) to keep a record of the files copied.

You can also add `--dry-run` to see what will happen before you start.

We'll start off by copying the content *.DAT* files, this will be a substantial portion of the database and most of these are not being modified (the most recent handful may be modified, and new ones are created, but that's ok).

    rclone copy source:mailarchive destination:mailarchive --filter "- index*" --filter "+ *.dat" --filter "- **" --min-age 1d

You'll possibly have a few errors, that's fine and they can be ignored at this stage. Run it again if you want it to get caught up on any remaining files, but don't worry about getting every last file.

Now we'll run it again copying even more files, excluding the `.fdb` files as these will be modified. Additionally we'll skip anything modified in the last day as these are likely to be modified again.

    rclone copy source:mailarchive destination:mailarchive --filter "- *.fdb" --min-age 1d

Now we're ready to stop archiving, so login to the existing server with MailStore Client, go to the *Storage Locations* panel, find the Storage Location marked as *Archive Here* and switch it to *Normal*, and copy everything except the `.fdb` files:

    rclone copy source:mailarchive destination:mailarchive --filter "- *.fdb"

This will copy the remaining index files and recovery records even if they've been modified recently, but still skipping the .fdb files as they will be modified by MailStore again. You can run it again to retry any errors, but it isn't critical.

### Complete the transfer

Finally, stop the service on the old server (and if you already installed the service on the new machine, make sure it is stopped there too). 

This time we'll use the `sync` command instead of `copy`, to ensure the destination matches completely.

    rclone sync source:mailarchive destination:mailarchive

In this case there should be no errors, if you see any errors at all then make sure the service is stopped (on both sides) and run it again as needed until successful.

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
