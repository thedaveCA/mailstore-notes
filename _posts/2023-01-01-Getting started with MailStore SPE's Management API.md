---
title: Getting started with MailStore SPE's Management API
categories: MailStoreSPE
tags: scripting API
published: true
--- 
# Enable the API

The API might already be enabled, but let's check that it is enabled before proceeding: 

1. Launch the *MailStore Service Provider Edition Configuration* tool.

2. Stop the *Management Server*.

3. Click *Configure...*.

4. Ensure *API HTTP Server Enabled* is checked.

5. Set *Listeners* to `*:8474` (without the quotes).

6. Copy the *Certificate* field from **Management Server Settings** and paste it in to the *Server Certificate* field in the API section.

7. Click *OK*.

8. *Start* the *Management Service*


# Using the PowerShell wrapper

## Wrapper and sample code

Referring to the PowerShell API Wrapper and sample code found in: <https://help.mailstore.com/en/spe/PowerShell_API_Wrapper_Tutorial>

### Set-ExecutionPolicy to run downloaded scripts

1.  Launch PowerShell as administrator

2.  Run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`

### Make our first API call

1.  Download *MailStore PowerShell API Wrapper and tutorial example scripts* from https://help.mailstore.com/en/spe/images/1/19/MailStore_SPE_Scripting_Tutorial.zip

2. Unzip `MailStore_SPE_Scripting_Tutorial.zip`

3.  Open the `MailStore SPE Scripting Tutorial\PowerShell\Scripts` directory.

4.  Edit *Example1.ps1*.

5.  Set the username/password.

6.  Adjust the managementserver and port (if needed). If you're working on the management server itself then the defaults should be fine.

7.  Run `.\Example1.ps1`

The result I get is:

    error           :
    token           :
    statusVersion   : 2
    statusCode      : succeeded
    percentProgress :
    statusText      :
    result          : @{version=22.4.0.21151; webClientVersion=22.4.0.21151; copyright=Copyright (c) 2005-2022 MailStore
                      Software GmbH; licenseeName=ehemaliger Testaccount; licenseeID=10510;
                      serverName=spe-server.example.com; username=admin; systemProperties=}
    logOutput       :

*Example2.ps* shows how to pass parameters using `"GetInstances" @{instanceFilter = "*"}`, and then it pulls the users from within each instance as an example of how to repeat an operation through different instances. It should just be a matter of updating the connection string in this script with your servername and credentials.

# Call the HTTPS API directly

## Install a browser extension

I'm using RESTClient (Firefox-based extension to make API calls interactively from a browser): <https://addons.mozilla.org/en-US/firefox/addon/restclient/> but other tools should be fine.

For reference my server's API is available at:
<https://spe-server.example.com:8474>

## Trust the certificate

1.  First access the URI and allow the untrusted certificate (if needed)

2.  Do this by visiting <https://spe-server.example.com:8474/>

3.  Advanced -> Accept the certificate

4.  Close the tab when prompted for credentials.

## Make a first call to the API

1.  Now launch RESTClient

2.  Click the Authentication tab

3.  Set the admin username/password.

4.  Change the **Method** to *Post*

5.  Call `https://spe-server.example.com:8474/api/invoke/GetInstanceHosts` (without the quotes)

My response looks like this:

    {
      "error": null,
      "token": null,
      "statusVersion": 2,
      "statusCode": "succeeded",
      "percentProgress": null,
      "statusText": null,
      "result": [
        {
          "serverName": "spe-server.example.com",
          "port": 8472,
          "serverCertificate": {
            "thumbprint": "A61597D8316DC39E26466F22C4C42B0C824ABE12"
          },
          "baseDirectory": null
        }
      ],
      "logOutput": null
    }

I used this API method because we can now add a body to test.

## Add parameters to apply a filter

I'll add the body `serverNameFilter=doesnotexist` (again, without the quotes) and we see no errors, but also no servers were returned, so we know the server accepted the parameter as the behaviour changed from above:

    {
      "error": null,
      "token": null,
      "statusVersion": 2,
      "statusCode": "succeeded",
      "percentProgress": null,
      "statusText": null,
      "result": [],
      "logOutput": null
    }

And now I'll change the body to:

`serverNameFilter=spe-server.example.com`

Now we get the requested server again, confirming everything is working:

    {
      "error": null,
      "token": null,
      "statusVersion": 2,
      "statusCode": "succeeded",
      "percentProgress": null,
      "statusText": null,
      "result": [
        {
          "serverName": "spe-server.example.com",
          "port": 8472,
          "serverCertificate": {
            "thumbprint": "A61597D8316DC39E26466F22C4C42B0C824ABE12"
          },
          "baseDirectory": null
        }
      ],
      "logOutput": null
    }

## Make a more complex API call

Use *CreateSystemAdministrator* https://help.mailstore.com/en/spe/Management_API_-_Function_Reference#CreateSystemAdministrator to create a new system administrator. I selected this example because we need both a *json* parameter, and a second parameter that is not part of the *json* block.

1. Change the URI to: 
`https://spe-server.example.com:8474/api/invoke/CreateSystemAdministrator`

2. Change the body: 
`config={  "userName" : "bob",  "fullName" : "Bob the Admin",  "emailAddress" : "bob@example.com"}&password=Passw0rd!`

3. Submit to the server.


The result is "statusCode": "succeeded"

    {
      "error": null,
      "token": null,
      "statusVersion": 2,
      "statusCode": "succeeded",
      "percentProgress": null,
      "statusText": null,
      "result": null,
      "logOutput": null
    }

And to confirm it really did work, I verified I can login with my newly created administrator "bob" using the management web interface \*port 8470)

## curl

We could do the same from *curl* using this command line:

`curl -X POST -k -H 'Authorization: Basic YWRtaW46UGFzc3cwcmQhIQ==' -i 'https://spe-server.example.com:8474/api/invoke/CreateSystemAdministrator' --data 'config={  "userName" : "joe",  "fullName" : "Joe the Admin",  "emailAddress" : "joe@example.com"}&password=Passw0rd!'`
