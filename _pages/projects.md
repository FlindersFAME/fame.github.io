---
layout: single
permalink: /projects/
title: FAME Projects
author_profile: true
---

{% for post in site.categories.projects %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}
