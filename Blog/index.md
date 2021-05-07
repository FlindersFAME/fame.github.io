---
layout: single
permalink: /blog/
title: Recent blog posts
author_profile: true
---

{% for post in site.categories.Blog limit:5 %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}

---

{% if site.categories.Blog.size > 5 %}
### [All blog posts](/blog-archive/)
{% endif %}
