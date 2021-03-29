---
layout: single
permalink: /events/
title: FAME Events
author_profile: true
---

FAME hosts regular meetings and occasional workshops throughout the year.
Our regular meetings include:
 - FAME microbiome and metagenome monthly meeting
 - Flinders University weekly Bioinformatics meeting

Upcoming events are listed below.
To receive reminders, [join the mailing list or the FAME slack channel](/follow-us/)

---

### Upcoming Events

{% for post in site.categories.events %}
<a href="{{ post.url }}">{{ post.title }}</a><br>{{ post.excerpt | strip_html }} 
{% endfor %}

