---
layout: splash
permalink: /events/
title: FAME Events
---

<table style="margin-left: auto; margin-right: auto;">
 {% for post in site.categories.Events %}
 <tr>
  <th>
   <div class="event__avatar">
    <img src="{{ post.header.teaser }}" style="float: left; margin-right: 20pt;">
   </div>
  </th>
  <th>{% include archive-single.html type=grid %}</th>
 </tr>
 {% endfor %}
</table>
