---
layout: splash
permalink: /events/
title: FAME Events
---

<table style="margin-left: auto; margin-right: auto;">
 {% for post in site.categories.Events %}
 <tr>
  <th>
   <div style="vertical-align: top; margin-left: auto; margin-right: 0;">
    <img src="{{ post.header.teaser }}" style="float: right; margin-right: 20pt; max-width: 200px; max-height: 200px; padding: 5px; border: 1px solid black;">
   </div>
  </th>
  <th>{% include archive-single.html type=grid %}</th>
 </tr>
 {% endfor %}
</table>
