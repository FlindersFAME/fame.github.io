---
layout: single
show_date: true
tags: DeepThought Jupyter
author: Rob Edwards
title: How to run a Jupyter notebook on deepthought
excerpt: "Most of these instructions come from the official jupyter docs and you should use those as a guide"
---

### _Series: An Introduction To Using DeepThought For Bioinformatics_

Most of these instructions come from the [official jupyter docs](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html) 
and you should use those as a guide. I have distilled this to the essence, to make it easier to complete on deepthought.


## Set up

Before you run jupyter-notebook for the first time, we need to do some set up. If you have done this, you can skip to the [next step](#getting-started).

### Install jupyter

Before beginning you will need to install the jupyter commands. You need to make sure you have the `python module` loaded. You should have added this to your `~/.bashrc` in a previous lesson. If you get command not found after this, talk to Rob.

```
pip3 install --user jupyter
```

### Set up the notebook

We start by running the automatic configurator command:

```
jupyter notebook --generate-config
```


### Make a self-signed certificate

We are going to make a `certificate` so that we can use encryption on our connection to stop people spying on us.

Use this command to create the certificate.

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/.jupyter/jupyter.key -out ~/.jupyter/jupyter.pem
```

It will ask you several questions. I answered like this ... but you should put your name and email!

```
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:SA
Locality Name (eg, city) []:Adelaide
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Flinders
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:Rob Edwards
Email Address []:robert.edwards@flinders.edu.au
```

### Edit the configuration file

We need to make some changes to the configuration file to let jupyter know where everything is. Use `nano` to edit the file:


```
nano ~/.jupyter/jupyter_notebook_config.py
```

We want to find the line that looks like `#c.NotebookApp.certfile=''`. For each of the lines, we are going to use the search command, `Ctrl-w` (for Where Is?). Press the `Ctrl` and `w` keys and the search box will appear at the bottom left of the screen. Type `certfile` and press return and nano will jump to that line.

You can leave that line as it is.

After that line paste these lines

```
c.NotebookApp.certfile = '$HOME/.jupyter/jupyter.pem'
c.NotebookApp.keyfile = '$HOME/.jupyter/jupyter.key'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8004
```

Press `Ctrl-o` to save the file (`o`utput) and then `Ctrl-x` to e`x`it nano.



