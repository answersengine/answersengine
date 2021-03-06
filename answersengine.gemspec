
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "answersengine"
  spec.version       = "0.10.2"
  spec.authors       = ["Parama Danoesubroto"]
  spec.email         = ["perry@datahen.com"]

  spec.summary       = %q{(Deprecated: Use datahen gem instead.) Compatibility alias for DataHen toolbelt for developers.}
  spec.description   = %q{(Deprecated: Use datahen gem instead.) Compatibility alias for DataHen toolbelt to develop scrapers and other scripts.}
  spec.homepage      = "https://datahen.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/answersengine/answersengine"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.2.2'
  spec.add_dependency "datahen", ">= 0"
  spec.add_development_dependency 'bundler', '>= 1.16'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'minitest', '>= 5.11'
  spec.add_development_dependency 'byebug', '>= 0'
end
