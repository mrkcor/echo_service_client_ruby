ENV['RACK_ENV'] = 'test'

require_relative '../echo'
require 'minitest/autorun'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = "#{File.dirname(__FILE__)}/vcr_cassettes"
  c.stub_with :fakeweb
end

