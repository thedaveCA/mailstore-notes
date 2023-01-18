---
title: Extracting unknown e-mail addresses from journal-type profile's debug log via Linux_WSL-47154077
categories: MailStoreServer MailStoreSPE
tags: ServerUnmappableException importing
published: true
permalink: ServerUnmappableException-wsl
--- 
This is part of a larger set of steps to set up a fresh MailStore Server and migrate messages from another archiving platform where the list of older users is not known.

This article just covers the steps to use WSL (Windows Subsystem for Linux) to get the e-mail addresses, [the full process is described here](ServerUnmappableException.md).

### Linux / bash command line

From here we need to extract the e-mail addresses that match your users. If you are comfortable at a Linux command line we can do this easily:

```bash
grep --only-matching --no-filename --extended-regex "[^ ]+@example\.com\b" *.log | sort | uniq > userlist.txt
```

If completed this way, move ahead to **Create the users**.

### WSL (Windows Subsystem for Linux)

Installing and learning WSL is out of scope for this article, but if you already have WSL on a machine that you can use, then from `cmd.exe` you can call WSL and convert the debug log into the needed text-file format like this:

```cmd
wsl grep --only-matching --no-filename --extended-regex "[^ ]+@example\.com\b" *.log ^| sort ^| uniq > userlist.txt
```

If completed this way, move ahead to **Create the users**.