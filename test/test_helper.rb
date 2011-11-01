ENV['RACK_ENV'] = 'test'

require_relative '../echo'
require 'minitest/autorun'
