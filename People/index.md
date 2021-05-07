---
layout: single
permalink: /people/
title: FAME-ous people
author_profile: true
ptags:
  - Group Leaders
  - Researchers
  - Students
---


{% for ptag in page.ptags %}
## {{ ptag }}
  {% for post in site.categories.People reversed %}
    {% if post.tags contains ptag %}
<div class="author__avatar">
  <img src="{{ site.data.authors[post.author].avatar }}" style="float: left; margin-right: 20pt;">
</div>
<a href="{{ post.url }}">{{ post.title }}</a><br>
{{ post.excerpt }}
<br>
    {% endif %}
  {% endfor %}
{% endfor %}
