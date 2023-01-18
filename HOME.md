---
title: /
layout: default
permalink: /
toplink: left
---

  <article>
{% for post in site.posts %}
{% if post.categories == empty %}
    <h2>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>
    {{ post.content | markdownify | strip_html | truncatewords: 50 }}
{% endif %}
{% endfor %}
{% for post in site.posts %}
{% if post.categories != empty %}
    <h2>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>
    {{ post.content | markdownify | strip_html | truncatewords: 50 }}
{% endif %}
{% endfor %}
  </article>
