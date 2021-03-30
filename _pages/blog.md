---
layout: single
permalink: /blog/
title: Recent blog posts
author_profile: true
---

{% for post in site.categories.blog limit:5 %}
<h4><a href="{{ post.url }}">{{ post.title }}</a></h4>
<small>{{ post.date | date_to_string }}</small>
<p>{{ post.excerpt | strip_html }}</p> 
{% endfor %}

---

{% if site.categories.blog.size > 5 %}
### [All blog posts](/blog-archive/)
{% endif %}
