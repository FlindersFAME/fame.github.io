---
layout: splash
author_profile: true
permalink: /software/
title: FAME Bioinformatics Software
---

Check out our amazing, well-maintained, open-source, and freely available Bioinformatics software!

{% assign sortedPosts = site.categories.Software | sort: 'title' %}
{% for post in sortedPosts %}
  {% include archive-single.html type=entries_layout %}
  <br>
{% endfor %}





