lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "sortable-for-rails"
  spec.version       = "1.2.1"
  spec.authors       = ["Grzegorz Derebecki"]
  spec.email         = ["grzegorz.derebecki@fdb.pl"]

  spec.summary       = %q{Allow easy sorting tables tables in rails}
  spec.description   = %q{Allow easy sorting tables tables in rails}
  spec.homepage      = "https://github.com/madmax/sortable-for-rails"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/madmax/sortable-for-rails"
  spec.metadata["changelog_uri"] = "https://github.com/madmax/sortable-for-rails"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 5.2"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"

end
