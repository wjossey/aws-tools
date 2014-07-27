$:.unshift(File.dirname(__FILE__) + '/lib')

require 'aws-tools'

Gem::Specification.new do |s|
  s.name = 'aws-tools'
  s.version = AWSTools::VERSION
  s.summary = 'AWS SDK for Ruby'
  s.description = s.summary
  s.license = 'Apache 2.0'
  s.author = 'Amazon Web Services'
  s.homepage = 'http://aws.amazon.com/sdkforruby'

  s.add_dependency('nokogiri', '>= 1.4.4')
  s.add_dependency('json', '~> 1.4')

  s.files = []
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['lib/**/*.yml']

  s.bindir = 'bin'
  s.executables << 'aws-tools'
end
