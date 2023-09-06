---
layout: splash
author_profile: true
permalink: /software/
title: FAME Bioinformatics Software
---

Check out our amazing, well-maintained, open-source, and freely available Bioinformatics software!

{% assign sortedPosts = site.categories.Software | sort: 'title' %}

<table style="margin-left: auto; margin-right: auto;">
 {% for post in sortedPosts %}
 <tr>
  <th>
   <div style="vertical-align: top; margin-left: auto; margin-right: 0;">
    <img src="{{ post.logo }}" style="float: right; margin-right: 20pt; max-width: 300px; max-height: 150px;">
   </div>
  </th>
  <th>{% include archive-single.html type=grid %}</th>
 </tr>
 {% endfor %}
</table>
