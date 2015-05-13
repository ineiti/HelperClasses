require 'helper_classes/hashaccessor'

using HelperClasses::HashAccessor

a = { :a => 3, "b" => 4 }

p a.to_sym
p a._a
p a._b
