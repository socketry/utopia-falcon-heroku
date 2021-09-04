
prepend Actions

require 'async/barrier'
require 'async/http/internet/instance'

on 'index' do
	numbers = 10.times.map{rand}
	internet = Async::HTTP::Internet.instance
	
	barrier = Async::Barrier.new
	
	numbers.each do |number|
		barrier.async do
			internet.get("http://httpbin.org/delay/#{number}") do |response|
				response.read
			end
		end
	end
	
	barrier.wait
	
	succeed! content: "Hello World!"
end