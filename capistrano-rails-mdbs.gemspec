lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "capistrano/rails/mdbs/version"

Gem::Specification.new do |spec|
  spec.name          = "capistrano-rails-mdbs"
  spec.version       = Capistrano::Rails::Mdbs::VERSION
  spec.authors       = ["De gentiile carl"]
  spec.email         = ["carl@quimeo.fr"]

  spec.summary       = %q{}
  spec.description   = %q{Add special task or migrate all databases}
  spec.homepage      = %q{https://github.com/quimeo/capistrano-rails-mdbs}
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency'capistrano-rails', '~> 0'
end
