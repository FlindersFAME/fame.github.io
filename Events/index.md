---
layout: splash
permalink: /events/
title: FAME Events
---

<table style="margin-left: auto; margin-right: auto;">
 {% for post in site.categories.Events %}
 <tr>
  <th>
   <div style="display: table-cell; vertical-align: top;">
    <img src="{{ post.header.teaser }}" style="float: left; margin-right: 20pt; max-width: 200px; max-height: 200px; padding: 5px; border: 1px solid black;">
   </div>
  </th>
  <th>{% include archive-single.html type=grid %}</th>
 </tr>
 {% endfor %}
</table>
