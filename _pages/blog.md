---
layout: single
permalink: /blog/
title: Recent blog posts
author_profile: true
---

{% for post in site.categories.blog limit:5 %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}

---

{% if site.categories.blog.size > 5 %}
### [All blog posts](/blog-archive/)
{% endif %}
