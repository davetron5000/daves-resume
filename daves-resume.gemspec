spec = Gem::Specification.new do |s| 
  s.name = 'daves-resume'
  s.version = '0.1.1'
  s.author = 'David Copeland'
  s.email = 'davidcopeland@naildrivin5.com'
  s.homepage = 'http://www.naildrivin5.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Command Line tools to manage your resume and generate it in various formats'
  s.files = [
    'ext/make_commandline_gemproof.rb',
    'ext/position_filter.rb',
    'ext/string_tags.rb',
    'lib/formatter.rb',
    'lib/resume.rb',
    'lib/serializer.rb',
    'templates/HTML.erb',
    'templates/Markdown.erb',
    'templates/RTF.erb',
  ]
  s.require_paths << 'ext'
  s.require_paths << 'lib'
  s.bindir = 'bin'
  s.executables << 'dr'
  s.executables << 'dr-format'
  s.executables << 'dr-scaffold'
  s.has_rdoc = true
  s.extra_rdoc_files = ['lib/README.rdoc']
  s.rdoc_options << '--title' << "Dave's Resume Build and Formatter" << '--main' << 'lib/README.rdoc'
  s.add_dependency('commandline', '>= 0.7.10')
end

