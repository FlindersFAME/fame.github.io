---
layout: single
author_profile: true
permalink: /software/
title: FAME Bioinformatics Software
---

Many Bioinformatics tools for performing a variety of analyses have been created by current and past members of FAME.
Browse our currently-maintained, open-source, and freely available Bioinformatics tools by category below.


{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
  {% assign zz = tag[1] | where: "category", "Software" | sort %}
  {% if zz != empty %}

<h3>{{ tag[0] }}</h3>
<details>
  <summary>
    (<i>Click to show {{ tag[0] }} tools</i>)
  </summary>
  <ul>
    {% for post in tag[1] reversed %}
      {% if post.category == "Software" %}
    {% include archive-single.html type=entries_layout %}
      {% endif %}
    {% endfor %}
  </ul>
</details>

  {% endif %}
{% endfor %}



