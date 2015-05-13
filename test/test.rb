#!/usr/bin/env ruby
$LOAD_PATH.push '../lib', '.'

require 'test/unit'
require 'helper_classes'
include HelperClasses

tests = Dir.glob( 'hc_*.rb' )
#tests = %w(  )

tests.each{|t|
  begin
    require "hc_#{t}"
  rescue LoadError => e
    require t
  end
}
