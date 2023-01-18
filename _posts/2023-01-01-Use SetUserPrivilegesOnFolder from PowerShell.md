---
title: Use SetUserPrivilegesOnFolder from PowerShell
categories: MailStoreServer
tags: scripting API PowerShell
published: true
--- 
First please refer to the [MailStore PowerShell API Wrapper](https://help.mailstore.com/en/server/PowerShell_API_Wrapper_Tutorial) article for instructions on the system requirements and basics of the PowerShell wrapper.

Once you have PowerShell installed and the API Wrapper downloaded, enter the commands from the documentation to load the module and establish a connection:

```Import-Module '..\API-Wrapper\MS.PS.Lib.psd1'```  

```$msapiclient = New-MSApiClient -Username admin -Password MyAdminPa$$W0rd -MailStoreServer localhost -Port 8463 -IgnoreInvalidSSLCerts```  


And now we can verify the connection with _GetServerInfo_:

```Invoke-MSApiCall $msapiclient "GetServerInfo" | fl```  

This will only work if you are on the MailStore Server, if you are on your own workstation then update the "localhost" to point to the correct hostname or IP. Similarly, update the port "8463" if needed.

I can confirm the connection from there (including just the relevant line):

```PS C:\> Invoke-MSApiCall $msapiclient "GetServerInfo" | fl```

```
error           :
token           :
statusVersion   : 2
statusCode      : succeeded
percentProgress :
statusText      :
result          : @{version=22.3.0.21002; machineName=EXCHANGEDC}
logOutput       :
```


I then used this command to pull _GetUserInfo_: 

```(Invoke-MSApiCall $msapiclient "GetUserInfo" @{"userName" = "frank.clark"}).result | fl```

```
username            : frank.clark
fullName            : Frank Clark
distinguishedName   : CN=Frank Clark,OU=Seattle,DC=example, DC=com
authentication      : directoryServices
emailAddresses      : {frank.clark@example.com}
pop3UserNames       : {}
privileges          : {login}
privilegesOnFolders : {@{folder=frank.clark; privileges=System.Object[]}, @{folder=abby.hernandez; privileges=System.Object[]}}
```

And next I added a permission: 

```Invoke-MSApiCall $msapiclient "SetUserPrivilegesOnFolder" @{"userName" = "frank.clark"; "folder" = "alexis.page"; "privileges" = "read"}| fl```


```
error           :
token           :
statusVersion   : 2
statusCode      : succeeded
percentProgress :
statusText      :
result          :
logOutput       :
```

And then check the permissions again to confirm the additional permission was added:

```(Invoke-MSApiCall $msapiclient "GetUserInfo" @{"userName" = "frank.clark"}).result | fl```

```
username            : frank.clark
fullName            : Frank Clark
distinguishedName   : CN=Frank Clark,OU=Seattle,DC=example, DC=com
authentication      : directoryServices
emailAddresses      : {frank.clark@example.com}
pop3UserNames       : {}
privileges          : {login}
privilegesOnFolders : {@{folder=frank.clark; privileges=System.Object[]}, @{folder=abby.hernandez; privileges=System.Object[]}, @{folder=alexis.page; privileges=System.Object[]}}
```