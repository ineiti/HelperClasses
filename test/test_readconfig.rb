#!/usr/bin/env ruby

$LOAD_PATH.push('../lib')
require 'helperclasses/readconfig'

include HelperClasses

testfile = 'test_config'
IO.write(testfile, "#!/bin/bash
# This is an example config
TEST=hi
DB=foo.db
# This shouldn't pass
TEST2 = hi
# And some unrelated stuff
if '$1'; then
fi
")

test = ReadConfig.bash( testfile )
p test

def printit
  p test
end

printit