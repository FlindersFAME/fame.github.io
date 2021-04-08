---
layout: single
permalink: /events/
title: FAME Events
author_profile: true
etags:
  - Regular meetings
  - Upcoming events
---

FAME hosts regular meetings and occasional workshops throughout the year.
To receive reminders for upcomming events, [join the mailing list or the FAME slack channel](/follow-us/)


{% capture nowunix %}{{ 'now' | date: '%s' }}{% endcapture %}

{% for etag in page.etags %}

## {{ etag }}

    {% for post in site.categories.events reversed %}
        {% if post.tags contains etag %}
            {% capture expiretime %}{{ post.expires | date: '%s'}}{% endcapture %}
            {% if expiretime > nowunix %}

{% include archive-single.html type=entries_layout %}


            {% endif %}
        {% endif %}
    {% endfor %}
{% endfor %}

