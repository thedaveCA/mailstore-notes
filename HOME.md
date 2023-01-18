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
      {% if post.tags != empty %}
      <h6>Tags: {{ post.tags | array_to_sentence_string }}</h6>
      {% endif %}
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
      {% if post.tags != empty %}
      <h6>Tags: {{ post.tags | array_to_sentence_string }}</h6>
      {% endif %}
    {{ post.content | markdownify | strip_html | truncatewords: 50 }}
{% endif %}
{% endfor %}
  </article>
