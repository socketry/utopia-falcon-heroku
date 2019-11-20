
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
		response = client.get(endpoint.path, [], body)
		
		Async do
			while line = input.gets
				body.write(line)
			end
		ensure
			body&.close
		end
		
		response.each do |chunk|
			$stdout.puts chunk
		end
	ensure
		response&.finish
		client&.close
	end
end
