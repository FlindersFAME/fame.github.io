---
layout: single
permalink: /blog-archive/
title: All blog posts
author_profile: true
---

{% for post in site.categories.blog %}
<a href="{{ post.url }}">{{ post.title }}</a>
<small> <i>({{ post.date | date_to_string }})</i> </small>
<br>
{{ post.excerpt | strip_html }} 
{% endfor %}

