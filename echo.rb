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
  def initialize(output = STDOUT)
    # Initialize SOAP client using the WSDL
    @client = Savon::Client.new("http://localhost:9292/echo_service.wsdl")
    # Set ouput for Echo class
    @output = output
  end

  # Call Echo on the EchoService
  def echo(message)
    echo_request(message)
  end

  # Call ReverseEcho on the EchoService
  def reverse_echo(message)
    echo_request(message, true)
  end

  private

  # Send Echo (or ReverseEcho if the reverse parameter is true) request to the EchoService
  # Return resulting message
  def echo_request(message, reverse = false)
    if reverse
      request_name = "ReverseEcho"
      response_name = :reverse_echo_response
    else
      request_name = "Echo"
      response_name = :echo_response
    end

    response = @client.request :echo, "#{request_name}Request", :body => { "Message" => message } do
      # The EchoService has its messages in a different namespace than the
      # targetNamespace of the WSDL, specify it here to have the request
      # rendered properly
      soap.namespaces["xmlns:echo"] = "http://www.without-brains.net/echo"
    end
    # Get the message from the response and output and return it
    data = response.to_array(response_name).first
    @output.puts "EchoService responded to #{request_name}: #{data[:message]}"
    data[:message]
  rescue Savon::Error => exception
    # In case of a SOAP fault or HTTP error output the error message
    #
    # Savon::Error is a generic exception that catches both SOAP faults and
    # HTTP errors, if you want you can catch more specific exceptions in your 
    # code to handle specific faults (Savon::SOAP::Fault for SOAP faults and
    # Savon::HTTP::Error for HTTP errors)
    @output.puts "An error occurred while calling #{request_name} on the EchoService: #{exception.message}"
  end
end

if __FILE__ == $0
  # When running this file directly make use of the Echo class to interact with the EchoService
  message = ARGV[0] || "Hello from Ruby"

  # Initialize the EchoService client and call operations
  echo = Echo.new
  echo.echo(message)
  echo.reverse_echo(message)
end
