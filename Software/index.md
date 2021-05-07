---
layout: single
author_profile: true
permalink: /software/
title: FAME Bioinformatics Software
---

Many Bioinformatics tools for performing a variety of analyses have been created by current and past members of FAME.
Browse our currently-maintained, open-source, and freely available Bioinformatics tools by category below.


{% for post in site.categories.Software %}
  {% include archive-single.html type=entries_layout %}
{% endfor %}





