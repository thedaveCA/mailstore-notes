---
title: Migrating a "live" MailStore Server
categories: MailStoreServer
tags: importing tips
published: true
---

## Migrating a "live" MailStore Server

If you are moving MailStore to a server in another office, a cloud-hosted virtual machine or leased server, or have a substantial amount of data then it can take a significant amount of time to move MailStore's database to another server.

Ideally you should schedule a maintenance window and follow the official instructions, but if MailStore is business-critical to your users this may not be ideal. This article describes the steps to reduce downtime to the absolute minimum.

### Upgrading versions

You can take advantage of the migration to upgrade to the current version of MailStore on the new server or perform any other maintenance tasks without disrupting access to the old server.

If you are looking to upgrade as part of the process, leave the old server running the existing version and install the new/current version of MailStore on the new server. There is no need to install an outdated version on the new server.

## The supported procedure

There is only one supported way to migrate a MailStore Server to another system, that is via the [Moving the Archive to a New Machine](https://help.mailstore.com/en/server/Moving_the_Archive#Moving_the_Archive_to_a_New_Machine) help article.

The process is (roughly) this:

1. Backup the data.
2. Shut down and remove the service from the old system.
3. Copy the files.
4. Install and activate the service.

This works great, but MailStore needs to be offline during the backup, and stay offline after that. But you can keep the old server running longer if you're careful.

## Another easy option

You can stop all archiving in MailStore while leaving the server functional (effectively in read-only mode) quite easily, so let's do that first: 

Login to MailStore Client as admin, go to *Administrative Tools* -> *Storage* -> *Storage Locations*, find the Storage Location marked as *Archive Here* and change it to *Normal* status.

On modern versions of MailStore this will block all archiving tasks, but leave other functions running normally. Older versions will try to archive, but without a storage location marked as Archive Here every message will fail and remain on the original server.

If you have a normal backup of MailStore Server, take an updated backup now, copy the database files to the new server, then proceed with the regular migration process. But if you only have a machine/VM image and don't want to restore it, or don't have a backup at all then you need to consider that taking a file-level backup will require downtime.

## The hard way

What if you wanted to keep the old server running nearly the entire time, and even archiving until you're very near the cutoff? Well, this is unsupported, but I've done this a few times without major issues.

You can do this in multiple ways, I'll cover robocopy and rclone, but any file copying/synchronization tool can get the job done.

The important part is that you do not block MailStore from accessing the database files, and avoid copying files that are still changing. In particular, do not copy or touch the `.FDB` files while MailStore is running.

Follow either the [robocopy instructions](2023-01-30-livemigration-robocopy.md) or the [rclone instructions](2023-01-30-livemigration-rclone.md).
