---
layout: single
show_date: true
tags : teams onedrive microsoft rclone deepthought
title: Using rclone, teams channels, and onedrive on deepthought
author: Robert Edwards
---

Recently, our HPC, [deepthought](https://deepteachweb.flinders.edu.au/dtdash/) has been running low on storage space. There are several options, but one that we are using is to combine deepthought, rclone, onedrive, and teams to move data into the cloud and share it with other users.

You need to start by connecting Teams and rclone.

## 1. Getting ready

You will need [rclone](https://rclone.org/) installed for this, but don't worry, you can `conda create -n rclone rclone` or `conda install rclone` depending if you want it in a new conda environment.

You will also need [MS Teams](https://www.microsoft.com/en-au/microsoft-teams/log-in) but you can't `conda install` that!

## 2. Choose a team

Each team in Teams gets 25 TB of storage. You can eiher use one of your existing teams or make a new one for this data.

## 3. Create a channel

You don't need to do this, but I find it a bit cleaner. In MS Teams, click the three dots and choose `Add Channel` 

[![](/assets/images/teamsrclone/addchannel.png)](/assets/images/teamsrclone/addchannel.png)

*Key:* Do not make the channel private, it will not work. I think you can do that later, but I can not access a private channel from `rclone`. (Let me know if you figure out how to do this!)


## 4. Connect rclone

Now log into deepthought, and start the rclone config:

```
$ rclone config
```

This will start a semi-automated configuration set up.


We start with your current configuration. You can see that I use `rclone` with several other online storage systems:

```
Current remotes:
Name                 Type
====                 ====
Box                  box
CloudStor            webdav
GoogleDrive          drive
OneDrive             onedrive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> n 
```

Here I choose `n` to start a new configuration.

And then create a name for the remote. This is what you will call it on the command line, so don't put spaces here. You can easily change this later by editing the `~/.config/rclone/rclone.conf` file. Note in section 4, we will use `SharedDataNotOnScratch` as the name. You should change this to something more meaningful (and easier to type).

```
Enter name for new remote.
name> SharedDataNotOnScratch
```


The next menu allows you to choose a lot of different setups. The one that you want here is called `onedrive` and I find it easier to just type that, rather than look through the whole list of drives:

```
Option Storage.
Type of storage to configure.
Choose a number from below, or type in your own value.    

<< long list of options>>
Storage> onedrive
```

The next set of questions you can leave empty and go with defaults. Note that the regions you should use `Microsoft Cloud Global`. You don't need advanced configuration.

```
Option client_id.
OAuth Client Id.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_id>

Option region.
Choose national cloud region for OneDrive.
Choose a number from below, or type in your own string value.
Press Enter for the default (global).
 1 / Microsoft Cloud Global
   \ (global)
 2 / Microsoft Cloud for US Government
   \ (us)
 3 / Microsoft Cloud Germany
   \ (de)
 4 / Azure and Office 365 operated by Vnet Group in China
   \ (cn)
region> 1


Edit advanced config?
y) Yes
n) No (default)
y/n> n
```

The next block is tricky, because deepthought is headless by definition, and you don't have access to the server. The easiest solution is to have another system with `rclone` installed where you can get the code from. It is not (too) ephemeral, and so you can run this on a separate machine and email the code back to yourself, and then copy/paste the email. The token is a long `json` formatted string, so you need to copy/paste it!

```
Use web browser to automatically authenticate rclone with remote?
 * Say Y if the machine running rclone has a web browser you can use
 * Say N if running rclone on a (remote) machine without web browser access
If not sure try Y. If Y failed, try N.

y) Yes (default)
n) No
y/n> n

Option config_token.
For this to work, you will need rclone available on a machine that has
a web browser available.
For more help and alternate methods see: https://rclone.org/remote_setup/
Execute the following on the machine with the web browser (same rclone
version recommended):
        rclone authorize "onedrive"
Then paste the result.
Enter a value.
config_token> <PASTE THE OUTPUT FROM THE OTHER WINDOW>>
```


Now we get to choose our team. 

```

Option config_type.
Type of connection
Choose a number from below, or type in an existing string value.
Press Enter for the default (onedrive).
 1 / OneDrive Personal or Business
   \ (onedrive)
 2 / Root Sharepoint site
   \ (sharepoint)
   / Sharepoint site name or URL
 3 | E.g. mysite or https://contoso.sharepoint.com/sites/mysite
   \ (url)
 4 / Search for a Sharepoint site
   \ (search)
 5 / Type in driveID (advanced)
   \ (driveid)
 6 / Type in SiteID (advanced)
   \ (siteid)
   / Sharepoint server-relative path (advanced)
 7 | E.g. /teams/hr
   \ (path)
config_type> config_type> 4
```

For me, the easiest way to do this is to search for a team. So in the search field I enter `FAME`, `Rob`, `Shared`, or someother keyword. In this case I use `FAME` and get a list of options, but I deleted the others so you can't see them!


```
Option config_search_term.
Search term
Enter a value.
config_search_term> FAME

Option config_site.
Select the Site you want to use
Choose a number from below, or type in your own string value.
Press Enter for the default (flinders.sharepoint.com,b11f2215-f2b9-4d7e-9587-0a28466208df,2b898a94-dad1-4602-b36d-12cef79fd4cf).
 1 / FAME Projects (https://flinders.sharepoint.com/sites/FAMEProjects)
   \ (flinders.sharepoint.com,9191445a-fae8-44f0-b683-39687b390067,c28733ac-6f49-4cf8-93bd-8d9560739148)
config_site> 1
```

Finally, we wrap up and are done!

```

Option config_driveid.
Select drive you want to use
Choose a number from below, or type in your own string value.
Press Enter for the default (b!WkSRkej68ES2gzloezkAZ6wzh8JJb_hMk72NlWBzkUhuaoTLoA1_S4pARHvAg55F).
 1 / Documents (documentLibrary)
   \ (b!WkSRkej68ES2gzloezkAZ6wzh8JJb_hMk72NlWBzkUhuaoTLoA1_S4pARHvAg55F)
config_driveid> 1

Drive OK?

Found drive "root" of type "documentLibrary"
URL: https://flinders.sharepoint.com/sites/FAMEProjects/Shared%20Documents

y) Yes (default)
n) No
y/n> y
```

Now you have added the data, its time to `rclone sync` it.

## 4. rclone it

The few commands I usually are:

--- | ---
Command | Meaning
--- | ---
`rclone lsd SharedDataNotOnScratch:` | List the top-level directories at the `SharedDataNotOnScratch` location
`rclone ls SharedDataNotOnScratch:` | Recursively ist the files at the `SharedDataNotOnScratch` location
`rclone sync LocalDirectory/ SharedDataNotOnScratch:RemoteDirectory/` | recursively copy the files from LocalDirectory/ into RemoteDirectory/. Like with `rsync`, the meaning of the trailing slash is important  - if they are both the same, like in the example, the RemoteDirectory will be created and the files will be right there.
`rclone copy localfile SharedDataNotOnScratch:remotefile` | copy a single file

Now you can move all your data off deepthought and onto MS Teams!
