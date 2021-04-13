
require 'async/websocket/adapters/rack'
require_relative 'live'

prepend Actions

on 'live' do |request|
	Console.logger.info("Incoming live connection...")
	
	adapter = Async::WebSocket::Adapters::Rack.open(request.env) do |connection|
		Live::Page.new(connection).run
	end
	
	respond?(adapter) or fail!
end

on 'index' do
	@tag = Live::ClickCounter.new('clicker')
end
