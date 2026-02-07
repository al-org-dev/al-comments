# Changelog

## 0.1.1 - 2026-02-07
- Improved config compatibility for comment rendering:
  - Supports both string and symbol keys for nested config values.
  - Supports `disqus.shortname` in addition to `disqus_shortname`.
  - Supports `giscus.repo` aliases and fallback from `repository` / `github.repository_nwo`.
  - Accepts common truthy flag values (`1`, `yes`, `on`) for `*_comments`.
- Added automated tests for Giscus/Disqus rendering paths and config fallbacks.

## 0.1.0 - 2026-02-07
- Initial gem release.
- Added standalone Giscus/Disqus comment rendering tag for Jekyll/al-folio sites.
