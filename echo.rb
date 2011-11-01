require 'bundler'
Bundler.setup
require 'savon'

class Echo
  def initialize
    @client = Savon::Client.new("http://localhost:9292/echo_service.wsdl") do
      wsdl.namespace = "http://www.without-brains.net/echo"
    end
  end

  def echo(message)
    response = @client.request :echo, "EchoRequest", :body => { "Message" => message }
    if response.success?
      data = response.to_array(:echo_response).first
      message = data[:message]
    end
  end

  def reverse_echo(message)
    response = @client.request :echo, "ReverseEchoRequest", :body => { "Message" => message }
    if response.success?
      data = response.to_array(:reverse_echo_response).first
      message = data[:message]
    end
  end
end
