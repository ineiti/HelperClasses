== HelperClasses

Some simple classes to help in everyday tasks

=== DPuts

Ever wanted to have detailed debug-output, but in the end even PRODUCING the
string without printing it was too long? Here comes DPuts! It let's you define
different debug-levels and the strings are only evaluated if they're about
to be printed! Great for that 10MB-dump that you only want for debugging...

Usage:

```
include HelperClasses::DPuts

DEBUG_LVL = 5
dputs(5){ "String with some #{huge_db.inspect}" }
```

This will evaluate and print the ```huge_db``` variable, while

```
include HelperClasses::DPuts

DEBUG_LVL = 4
dputs(5){ "String with some #{huge_db.inspect}" }
```

will NOT evaluate it! The debug-levels are arbitrarily chosen like this:

0 - Errors
1 - Info and warnings, important
2 - Often used debug-messages - limit of production-use
3 - More detailed debugging
4
5 - Dumping lots of raw data

=== Arraysym

to_sym and to_sym! - calls .to_sym on all elements. Usage:

```
using HelperClasses::ArraySym

p [ "a", "b" ].to_sym
```

Produces "[ :a, :b ]"

=== HashAccessor

This should be standard ruby. Access all elements of an array by
prepending a "_".

==== Getting a value

```
using HelperClasses::HashAccessor

p { :a => 2, "a" => 3 }._a
```

Will print "2". So symbols have precedence over string-keys.

==== Setting a value

```
using HelperClasses::HashAccessor

a = { :a => 2, "a" => 3 }
a._a = 4
a._b = 5

p a
```

Will print ```{ :a => 4, "a" => 3, :b => "5" }```
