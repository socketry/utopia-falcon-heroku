
require 'pathname'
SITE_ROOT = Pathname.new(__dir__).realpath

# Load all rake tasks:
import(*Dir.glob('tasks/**/*.rake'))

task :default => :development

task :echo do
	require 'async'
	require 'async/http/client'
	require 'async/http/endpoint'
	
	input = Async::IO::Stream.new(Async::IO.try_convert($stdin))
	
	Async do
		endpoint = Async::HTTP::Endpoint.parse(ENV['URL'])
		
		client = Async::HTTP::Client.new(endpoint)
		
		body = Async::HTTP::Body::Writable.new
		
		Async do
			Async.logger.info(body) {"Waiting for input from user, flushing each line, press Ctrl-D to close request body."}
			
			while line = input.gets
				Async.logger.info(body) {"Writing: #{line}"}
				body.write(line)
			end
		ensure
			Async.logger.info(body) {"Closing body..."}
			body&.close
		end
		
		response = client.post(endpoint.path, [], body)
		
		response.each do |chunk|
			$stdout.puts chunk
		end
	ensure
		response&.finish
		client&.close
	end
end
