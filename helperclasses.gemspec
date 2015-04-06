Gem::Specification.new do |s|
  s.name = 'helperclasses'
  s.version = '0.2.0'
  s.date = '2015-04-06'
  s.summary = 'Hash._accessor Array.to_sym and DPuts'
  s.description = 'Added accessors to Hash, to_sym to Array and a nice debugging-interface called DPuts'
  s.authors = ['Linus Gasser']
  s.email = 'ineiti@linusetviviane.ch'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.homepage =
      'https://github.com/ineiti/HelperClasses'
  s.license = 'GPLv3'
end
