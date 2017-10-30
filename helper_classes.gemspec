Gem::Specification.new do |s|
  s.name = 'helper_classes'
  s.version = '1.9.13-11'
  s.date = '2017-10-30'
  s.summary = 'Hash._accessor Array.to_sym and DPuts'
  s.description = 'Added accessors to Hash, to_sym to Array and a nice debugging-interface called DPuts'
  s.authors = ['Linus Gasser']
  s.email = 'ineiti.blue'

  s.files         = `if [ -d '.git' ]; then git ls-files -z; fi`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.homepage =
      'https://github.com/ineiti/HelperClasses'
  s.license = 'GPL-3.0'
end
