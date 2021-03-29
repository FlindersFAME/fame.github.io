---
layout: single
permalink: /projects/
title: FAME Projects
author_profile: true
---

{% for post in site.categories.projects %}
<a href="{{ post.url }}">{{ post.title }}</a><br>{{ post.excerpt | strip_html }} 
{% endfor %}
