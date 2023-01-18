---
title: Getting started with MailStore Server's Management API-25720158
categories: MailStoreServer
tags: scripting API
published: true
--- 
# Enable the API

The API might already be enabled, but let's check that it is enabled before proceeding: 

1. Launch the *MailStore Server Service Configuration Configuration* tool.

2. Go to the *Network Settings* panel.

3. Enable *MailStore Administration API (HTTPS)* and note the port.

4. Click *Restart Service* if you made any changes.

# Call the HTTPS API directly

## Install a browser extension

I'm using RESTClient (Firefox-based extension to make API calls interactively from a browser): <https://addons.mozilla.org/en-US/firefox/addon/restclient/> but other tools should be fine.

For reference my server's API is available <https://exchangedc.example.com:8463> but of course you'll need to use appropriate server name or IP address and port information.

## Trust the certificate

1.  First access the URI and allow the untrusted certificate (if needed)

2.  Do this by visiting the web interface at <https://exchangedc.example.com:8462>

3.  Advanced -> Accept the certificate

4.  Close the tab when prompted for credentials.

## Make a first call to the API

1.  Now launch RESTClient

2.  Click the Authentication tab

3.  Set the admin username/password.

4.  Change the **Method** to *Post*

5.  Call `https://exchangedc.example.com:8463/api/invoke/GetUsers` (without the quotes)

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
          "userName": "admin",
          "fullName": "Administrator",
          "distinguishedName": null
        },
        {
          "userName": "frank.clark",
          "fullName": "Frank Clark",
          "distinguishedName": null
        }
      ],
      "logOutput": null
    }

## Add parameters to apply a filter

Now change the URI to `https://exchangedc.example.com:8463/api/invoke/GetUserInfo`. If you were to submit now you'd get a response that start like this: 

    {
      "error": {
        "message": "Missing API argument userName.",
        "details": "System.Exception: Missing API argument userName.\r\n   at 

Add the body `userName=frank.clark` and we get a good response again: 

    {
      "error": null,
      "token": null,
      "statusVersion": 2,
      "statusCode": "succeeded",
      "percentProgress": null,
      "statusText": null,
      "result": {
        "userName": "frank.clark",
        "fullName": "Frank Clark",
        "distinguishedName": null,
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
          }
        ]
      },
      "logOutput": null
    }

You can see the additional user information is now availble, confirming everything is working.

## curl

We could do the same from *curl*, I'll jump straight to the command as a starting point.

`curl -X POST -k -H 'Authorization: Basic YWRtaW46UGFzc3cwcmQhIQ==' -i 'https://exchangedc.example.com:8463/api/invoke/GetUserInfo' --data 'userName=frank.clark'`

The response is the same as above so I won't repeat.