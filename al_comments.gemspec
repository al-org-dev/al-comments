Gem::Specification.new do |spec|
  spec.name          = 'al_comments'
  spec.version       = '0.1.0'
  spec.authors       = ['al-org']
  spec.email         = ['dev@al-org.com']
  spec.summary       = 'Comments integrations for al-folio-compatible Jekyll sites'
  spec.description   = 'Standalone Jekyll plugin that renders Giscus and Disqus comment blocks with theme-aware setup.'
  spec.homepage      = 'https://github.com/al-org-dev/al-comments'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'jekyll', '>= 3.0'
  spec.add_dependency 'liquid', '>= 4.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
