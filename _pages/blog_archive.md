---
layout: single
permalink: /blog-archive/
title: All blog posts
author_profile: true
---

{% for post in site.categories.blog %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}

