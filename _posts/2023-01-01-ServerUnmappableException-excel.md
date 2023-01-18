---
title: Extracting unknown e-mail addresses from journal-type profile's debug log via Excel-757d218f
categories: MailStoreServer MailStoreSPE
tags: ServerUnmappableException importing
published: true
permalink: ServerUnmappableException-excel
--- 
This is part of a larger set of steps to set up a fresh MailStore Server and migrate messages from another archiving platform where the list of older users is not known.

This article just covers the steps to use Excel and the Windows Command Line to get the e-mail addresses, [the full process is described here](ServerUnmappableException.md).

You could do this by hand using Excel as well although this has a lot more individual steps.

There are multiple ways to accomplish this, including using scripting, but I will attempt to provide easy-to-understand steps that allow you to see each step, and no scripting is required. Here is what I have done in the past:

Start with Windows' *find.exe* command to filter the log to just the relevant lines:

```cmd
find "MailStore.Common.Interfaces.ServerUnmappableException" < *.log > userlist.txt
````

- Open the resulting file in Excel.
- Use *Data* -> *Text to Columns*.
- Select *Delimited*.
- Set Delimiters to both "Comma" and "Space" only.
- Enable *Treat consecutive delimiters as one*.
- Click *Finish*.
- Look for the columns that contains e-mail addresses at the end of each line. This should start at *AA*.
- Copy the results and paste to a new sheet.
- Repeat for each column that has further e-mail addresses. There may be more than *AA* and *AB* as e-mail can have more than a single sender/recipient pair per message. Remember there may be lines that have no 3rd address followed by more lines that have a 3rd address, but if you miss any there is an opportunity to catch them later.

Now switch to the new sheet.

- Use *Data* --> *Remove Duplicates* to clean up the list.
- Insert a blank row at the top.
- Enable *Data* --> *Filter*.
- Click the down arrow on the top line to modify the filter.
- Type `example.com` in the *search* field and press enter.
- Copy the results and save it as `userlist.txt`