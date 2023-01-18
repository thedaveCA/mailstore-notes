---
permalink: /tags/
title: Tags
toplink: left
---

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
  {% assign t = tag | first %}
  {% assign posts = tag | last %}

{{ t | downcase }}
<ul>
{% for post in posts %}
  {% if post.tags contains t %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% if post.categories != empty %}<h6>Applies to: {{ post.categories | array_to_sentence_string }}</h6>{% endif %}
  {% endif %}
{% endfor %}
</ul>
{% endfor %}

untagged
<ul>
{% for post in posts %}
  {% if post.tags == empty or post.tags == nil %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% if post.categories != empty %}<h6>Applies to: {{ post.categories | array_to_sentence_string }}</h6>{% endif %}
  {% endif %}
{% endfor %}
</ul>
