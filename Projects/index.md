---
layout: single
permalink: /projects/
title: FAME Projects
author_profile: true
---

{% assign sortedPosts = site.categories.Projects | sort: 'title' %}
{% for post in sortedPosts %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}
