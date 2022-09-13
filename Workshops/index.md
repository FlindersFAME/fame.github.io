---
layout: single
permalink: /workshops/
title: FAME Workshops
author_profile: true
---

{% for post in site.categories.Workshops limit:5 %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}

---

{% if site.categories.Workshops.size > 5 %}
### [All workshops](/workshop-archive/)
{% endif %}