$:.unshift File.expand_path("../lib", __FILE__)
require 'ups_shipping'

Gem::Specification.new do |gem|
  gem.name    = "ups_shipping"
  gem.version = Shipping::VERSION

  gem.author      = "Transcriptic, Inc"
  gem.email       = "team@transcriptic.com"
  gem.homepage    = "http://www.github.com/transcriptic/ups-shipping"
  gem.summary     = "UPS shipping API integration."
  gem.description = "UPS shipping gem for integrating UPS's API into a Ruby script."

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(lib/|spec/)} }

  gem.add_dependency "nokogiri"
  gem.add_dependency "rspec"
  gem.add_dependency "httparty"
end