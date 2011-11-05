require_relative 'test_helper'

class TestEcho < MiniTest::Unit::TestCase
  def setup
    @output = StringIO.new
    @echo = Echo.new(@output)
  end

  def test_echo_gives_back_the_echo
    VCR.use_cassette("echo") do
      assert_equal "Hello from Ruby", @echo.echo("Hello from Ruby")
      assert_equal "EchoService responded to Echo: Hello from Ruby\n", @output.string
    end
  end

  def test_reverse_echo_gives_back_the_echo_in_reverse
    VCR.use_cassette("reverse_echo") do
      assert_equal "ybuR morf olleH", @echo.reverse_echo("Hello from Ruby")
      assert_equal "EchoService responded to ReverseEcho: ybuR morf olleH\n", @output.string
    end
  end
end
