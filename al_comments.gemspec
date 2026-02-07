Gem::Specification.new do |spec|
  spec.name          = "al_comments"
  spec.version       = "0.1.1"
  spec.authors       = ["al-org"]
  spec.email         = ["dev@al-org.dev"]
  spec.summary       = "Giscus and Disqus comments tag for Jekyll sites"
  spec.description   = "Jekyll plugin extracted from al-folio that renders theme-aware Giscus and Disqus comment blocks via a reusable Liquid tag."
  spec.homepage      = "https://github.com/al-org-dev/al-comments"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage
  }

  spec.files         = Dir["lib/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.9", "< 5.0"
  spec.add_dependency "liquid", ">= 4.0", "< 6.0"

  spec.add_development_dependency "bundler", ">= 2.0", "< 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
