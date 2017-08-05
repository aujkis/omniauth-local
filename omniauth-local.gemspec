$:.push File.expand_path("../lib", __FILE__)

require "omniauth-local/version"

Gem::Specification.new do |specification|
  specification.name        = 'omniauth-local'
  specification.version     = OmniauthLocal::VERSION
  specification.authors     = ["Austris Landmanis"]
  specification.email       = ["austris@chevron.lv"]
  specification.homepage    = 'https://github.com/cyanpunk/omniauth-local'
  specification.summary     = 'A simple email and password OmniAuth strategy.'
  specification.description = 'A simple email and password OmniAuth strategy.'

  specification.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "README.md"]

  specification.add_dependency 'rails', '~> 5.1.2'
  specification.add_runtime_dependency 'omniauth', '~> 1.6.1'
  specification.add_runtime_dependency 'bcrypt', '~> 3.1.11'
end
