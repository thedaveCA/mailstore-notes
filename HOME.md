---
title: /
layout: default
permalink: /
toplink: left
---

  <article>
{% for post in site.posts %}
{% if post.categories == empty %}
    <p><h2>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>
      {% if post.tags != empty %}
      <h6>Tags: {{ post.tags | array_to_sentence_string }}</h6>
      {% endif %}
    {{ post.content | markdownify | strip_html | truncatewords: 50 }}
    </p>
{% endif %}
{% endfor %}
{% for post in site.posts %}
{% if post.categories != empty %}
{% if post.categories != HelperArticles %}
    <p><h2>
      <a href="{{ post.url }}">
        {{ post.title }}
      </a>
    </h2>
      {% if post.tags != empty %}
      <h6>Tags: {{ post.tags | array_to_sentence_string }}</h6>
      {% endif %}
    {{ post.content | markdownify | strip_html | truncatewords: 50 }}
    </p>
{% endif %}
{% endif %}
{% endfor %}
  </article>
