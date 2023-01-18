---
title: /
layout: default
permalink: /
toplink: left
---

{% for post in site.posts %}
  <article>
    <h2>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>
    {{ post.content | markdownify | strip_html | truncatewords: 50 }}
  </article>
{% endfor %}
