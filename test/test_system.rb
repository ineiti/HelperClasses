#!/usr/bin/env ruby

require 'helper_classes/system'
include HelperClasses::System

rescue_all do
  puts 'Hello there'
end
puts

rescue_all do
  puts "Some math: #{10/0}"
end
puts

rescue_all('math-error') do
  puts "Some math: #{10/0}"
end