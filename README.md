# al-comments

`al_comments` provides reusable comment integrations for `al-folio` v1.x and compatible Jekyll sites.

## Features

- Giscus comments
- Disqus comments
- Theme-aware Giscus setup

## Installation

```ruby
gem 'al_comments'
```

```yaml
plugins:
  - al_comments
```

## Usage

Render comments where needed:

```liquid
{% al_comments %}
```

## Ecosystem context

- Starter wiring/examples live in `al-folio`.
- Comment integration behavior is plugin-owned here.

## Contributing

Comment-system support and runtime behavior changes should be proposed in this repository.
