$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'simplecov'
require 'simplecov-console'
SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start

require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'timecop'
require 'byebug'
require 'answersengine'
