Gem::Specification.new do |s|
  s.name        = 'HelperClasses'
  s.version     = '0.1.0'
  s.date        = '2014-05-28'
  s.summary     = "Helpers for Array, Hash and debug-output"
  s.description = "Array.to_sym, Hash-accessors and debug-outputs with lazy evaluation"
  s.authors     = ["Linus Gasser"]
  s.email       = 'ineiti@linusetviviane.ch'
  s.files       = ['README', 'LICENSE', 
    './lib/helperclasses',
    './lib/helperclasses/arraysym.rb',
    './lib/helperclasses/dputs.rb',
    './lib/helperclasses/hashaccessor.rb',
    './lib/helperclasses.rb',
    './LICENSE',
    './README',
    './test/test_arraysym.rb',
    './test/test_dputs.rb',
    './test/test_hashaccessor.rb' ]
  s.homepage    =
    'https://github.com/ineiti/HelperClasses'
  s.license       = 'GPLv3'
end
