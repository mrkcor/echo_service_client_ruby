require 'bundler'
Bundler.setup
require 'savon'

Savon.configure do |config|
  # Disable Savon logging (enable this to see details on the SOAP messages)
  config.log = false
end

# Diable HTTPI logging (enable this to see details on the HTTP requests being done by Savon)
HTTPI.log = false

class Echo
  def initialize
    # Initialize SOAP client using the WSDL
    @client = Savon::Client.new("http://localhost:9292/echo_service.wsdl")
  end

  def echo(message)
    response = @client.request :echo, "EchoRequest", :body => { "Message" => message } do
      # The EchoService has its messages in a different namespace than the
      # targetNamespace of the WSDL, specify it here to have the request
      # rendered properly
      soap.namespaces["xmlns:echo"] = "http://www.without-brains.net/echo"
    end
    # Get the message from the response and return it
    data = response.to_array(:echo_response).first
    data[:message]
  end

  def reverse_echo(message)
    response = @client.request :echo, "ReverseEchoRequest", :body => { "Message" => message } do
      # The EchoService has its messages in a different namespace than the
      # targetNamespace of the WSDL, specify it here to have the request
      # rendered properly
      soap.namespaces["xmlns:echo"] = "http://www.without-brains.net/echo"
    end
    # Get the message from the response and return it
    data = response.to_array(:reverse_echo_response).first
    data[:message]
  end
end

if __FILE__ == $0
  # When running this file directly make use of the Echo class to interact with the EchoService
  message = ARGV[0] || "Hello from Ruby"
  echo = Echo.new
  puts "EchoService responded to Echo: #{echo.echo(message)}"
  puts "EchoService responded to ReverseEcho: #{echo.reverse_echo(message)}"
end
