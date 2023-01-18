---
title: Use SetUserPrivilegesOnFolder from MailStoreCmd_exe-656b33ac
categories: MailStoreServer MailStoreSPE
tags: scripting MailStoreCmd
published: true
--- 
To use *MailStoreCmd.exe* we need to know a bit about the environment, but we can use MailStore Client to generate a working command line for us:

1.  Go to the *Archive E-mail* panel

2.  See if you have any *EML* or *PST* or *File System* profiles that already exist and skip the next step.

3.  If you don't have a profile you can use, create a *E-mail Files* --> *EML* profile, set the path to something that doesn't exist ("*C:\does-not-exist*"), leave the other options at their defaults until you get the checkbox to run the profile now and uncheck this. Save the profile.

4.  Now that you have a profile we can use, right click on it, choose *Create task on...*

5.  Press the *Copy CMD Line* button at the bottom.

6.  Paste into Notepad.

Mine looks like this:

```null
"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --pkv3="161F2004CB4B5735038E49F3C611D34349180BA9" --cred="admin@127.0.0.1" -c import-execute --id=3 --user="admin" --verbose
```

Cancel creating a scheduled task, we don't need it, but this is a shortcut to generating a command line and setting the credentials. Once we have the command line above you can delete the profile you created, we don't need it anymore.

Use your command rather than mine as it is personalized to your environment. We need everything up to the -c, this is where we specify the command we want to run, so for example with a base command line:

    "C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --pkv3="161F2004CB4B5735038E49F3C611D34349180BA9" --cred="admin@127.0.0.1" -c 

We can *GetServerInfo* to prove we are connected:

`"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --pkv3="161F2004CB4B5735038E49F3C611D34349180BA9" --cred="admin@127.0.0.1" -c `

The result:

    GetServerInfo
    Connecting...
    Disconnecting...

    *******************************************************************

          MailStore Command Line Client

          Version 22.3.0.21002

    *******************************************************************

    {
      "version": "22.3.0.21002",
      "machineName": "EXCHANGEDC"
    }

Now we will retrieve the current status of the user:

`"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --pkv3="161F2004CB4B5735038E49F3C611D34349180BA9" --cred="admin@127.0.0.1" -c GetUserInfo --userName="frank.clark"`

The result:

    Connecting...
    Disconnecting...

    *******************************************************************

          MailStore Command Line Client

          Version 22.3.0.21002

    *******************************************************************

    {
      "userName": "frank.clark",
      "fullName": "Frank Clark",
      "distinguishedName": "CN=Frank Clark,OU=Seattle,DC=example, DC=com",
      "authentication": "directoryServices",
      "emailAddresses": [
        "frank.clark@example.com"
      ],
      "pop3UserNames": [],
      "privileges": [
        "login"
      ],
      "privilegesOnFolders": [
        {
          "folder": "frank.clark",
          "privileges": [
            "read"
          ]
        },
        {
          "folder": "abby.hernandez",
          "privileges": [
            "read"
          ]
        },
        {
          "folder": "alexis.page",
          "privileges": [
            "read"
          ]
        }
      ]
    }

Now we will *SetUserPrivilegesOnFolder* to apply *"read, write"*:

`"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --pkv3="161F2004CB4B5735038E49F3C611D34349180BA9" --cred="admin@127.0.0.1" -c SetUserPrivilegesOnFolder --userName="frank.clark" --folder="abby.hernandez" --privileges="read, write"`

And the result:

    Connecting...
    Disconnecting...

    *******************************************************************

          MailStore Command Line Client

          Version 22.3.0.21002

    *******************************************************************

And finally we can check the results with the previous *GetUserInfo* command:

`"C:\Program Files (x86)\MailStore\MailStore Server\MailStoreCmd.exe" --h="localhost" --pkv3="161F2004CB4B5735038E49F3C611D34349180BA9" --cred="admin@127.0.0.1" -c GetUserInfo --userName="frank.clark"`

    Connecting...
    Disconnecting...

    *******************************************************************

          MailStore Command Line Client

          Version 22.3.0.21002

    *******************************************************************

    {
      "userName": "frank.clark",
      "fullName": "Frank Clark",
      "distinguishedName": "CN=Frank Clark,OU=Seattle,DC=example, DC=com",
      "authentication": "directoryServices",
      "emailAddresses": [
        "frank.clark@example.com"
      ],
      "pop3UserNames": [],
      "privileges": [
        "login"
      ],
      "privilegesOnFolders": [
        {
          "folder": "frank.clark",
          "privileges": [
            "read"
          ]
        },
        {
          "folder": "alexis.page",
          "privileges": [
            "read"
          ]
        },
        {
          "folder": "abby.hernandez",
          "privileges": [
            "read",
            "write"
          ]
        }
      ]
    }
