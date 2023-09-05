---
layout: splash
permalink: /people/
title: FAME-ous people
author_profile: true
ptags:
  - Group Leaders
  - Researchers
  - Students
  - Visiting Scholars
  - Alumni
---

# FAME-ous People!

![](/assets/images/peeps.jpg)

{% for ptag in page.ptags %}
## {{ ptag }}
  {% assign sortedPosts = site.categories.People | sort: 'title' %}
  {% for post in sortedPosts %}
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
