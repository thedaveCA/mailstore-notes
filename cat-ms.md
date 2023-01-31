---
permalink: /mailstoreserver/
title: Server
toplink: left
---
<h2>MailStore Server</h2>
<h3>All articles</h3>
<ul>
{% for post in site.posts %}
 {% if post.categories contains 'MailStoreServer' %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
      {% if post.tags != empty %}
      <h6>Tags: {{ post.tags | array_to_sentence_string }}</h6>
      {% endif %}
  {% endif %}
  {% endfor %}
</ul>
<hr>
<h3>Grouped by topic</h3>

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
  {% assign t = tag | first %}
  {% assign posts = tag | last %}

{{ t | downcase }}
<ul>
{% for post in posts %}
  {% if post.tags contains t %}
  {% if post.categories contains 'MailStoreServer' %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endif %}
  {% endif %}
{% endfor %}
</ul>
{% endfor %}
