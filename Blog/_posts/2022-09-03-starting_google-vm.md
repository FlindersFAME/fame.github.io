---
layout: single
show_date: true
tags : Google
title: How to start a Google VM
author: Rob Edwards
---

# Starting a Google VM

Sometimes you might want to spin up a Google VM to use:

**WARNING:** There maybe charges for starting a VM, running BigQuery searches, or generally working in the cloud!

YOU ARE SOLELY RESPONSIBLE FOR ANY CHARGES THESE SEARCHES INCUR.

- [Here is the pricing for each Virtual Machine]( )
- [Here is the pricing for Big Query Searches]( )

First, lets start a new VM.

Click the New Virtual Machine logo in [Google Cloud](https://console.cloud.google.com/)

![](/assets/images/google/newvm.png) 


(Depending on your settings, there may be an interstitial that requires you to Enable running VMs)

Then click create VM:

![](/assets/images/google/create.png) 


Note:

There are a lot of options about regions. I recommend using the cheapest region, not necessarily the closest region!

Currently on Google, Sydney and Melbourne are both $0.030950 / vCPU hour while Iowa is $0.021811 / vCPU hour

I set up a small machine that has

- Location: Iowa (us-central-1)
- Series: E2
- Machine Type: e2-micro (2 vCPU, 1 GB memory)


![](/assets/images/google/exampleVM.png)


The handy cost estimate suggests that this machine will cost me about US$7 per month. I can live with that

![](/assets/images/google/cost.png)

### Free tier!

However, on my allocation, this qualifies for my free tier (don't worry, they will get money out of me some other way)

It is a good idea to check that you are eligible for the free tier

![](/assets/images/google/free.png)


### Create the VM

Finally, after all that click the create button:

![](/assets/images/google/free.png)

### Access the machine

Once the machine has booted, you should see the machine listed in the [Google Cloud](https://console.cloud.google.com/compute/instances) console. You will need that IP address:

![](/assets/images/google/ip.png)



